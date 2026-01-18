import scrapy
from ..items import FacultyItem

class FacultySpider(scrapy.Spider):
    name = "faculty_spider"
    
    def __init__(self, start_url=None, *args, **kwargs):
        super(FacultySpider, self).__init__(*args, **kwargs)
        
        # Require a URL or raise an error for strict validation
        if start_url:
            self.start_urls = [start_url]
        else:
            raise ValueError("Ingestion Error: No start_url provided! Usage: -a start_url='URL'")

    def parse(self, response):
        # Navigate the directory and fetch profile links.
        try:
            faculty_links = response.css("div.personalDetails h3 a::attr(href)").getall()
            
            if not faculty_links:
                self.logger.error(f"Ingestion Error: No links found at {response.url}. Check CSS selectors.")
                return

            self.logger.info(f"Found {len(faculty_links)} faculty profiles. Starting deep fetch.")
            
            for link in faculty_links:
                yield response.follow(link, callback=self.parse_faculty)
                
        except Exception as e:
            self.logger.critical(f"Critical Failure in Parse: {str(e)}")

    def parse_faculty(self, response):
        # Extract specific entities and handle null values.
        try:
            item = FacultyItem()    

            # Basic Info
            img_src = response.css("div.field--name-field-faculty-image img::attr(src)").get()
            item['image_url'] = response.urljoin(img_src) if img_src else "No Image"
            
            item['name'] = response.css("div.field--name-field-faculty-names.field__item::text").get()
            item['qualification'] = response.css("div.field--name-field-faculty-name.field__item::text").get()
            item['phone'] = response.css("div.field--name-field-contact-no.field__item::text").get()
            
            # Contact Info
            item['address'] = response.css("div.field--name-field-address.field__item::text").getall() 
            item['email'] = response.css("div.field--name-field-email.field__items .field__item::text").getall()
            item['professional_link'] = response.url 
            
            # Professional Content
            item['biography'] = response.css("div.field--name-field-biography.field__item p::text").getall()
            item['specialization'] = response.css("div.work-exp p::text").getall()
            item['publications'] = response.css('div.education ul li ::text').getall()
            item['teaching'] = response.css("div.field--name-field-teaching.field__item li::text").getall()
            item['research'] = response.css("div.field--name-field-faculty-teaching.field__item ::text").getall()

            item['content_hash'] = None
            yield item

        except Exception as e:
            self.logger.error(f"Error extracting data from {response.url}: {str(e)}")