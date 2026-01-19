import scrapy
from ..items import FacultyItem

class FacultySpider(scrapy.Spider):
    name = "faculty_spider"
    
    def __init__(self, start_url=None, *args, **kwargs):
        """
        Accepts 'start_url' as a command-line argument.
        Usage: scrapy crawl faculty_spider -a start_url="https://www.daiict.ac.in/faculty"
        """
        super(FacultySpider, self).__init__(*args, **kwargs)
        
        # Require the URL to be passed as an argument
        if not start_url:
            raise ValueError("No start_url provided! Usage: scrapy crawl faculty_spider -a start_url='URL'")
        
        self.start_urls = [start_url]

    def parse(self, response):
        """Step 1: Navigate through the specific DA-IICT category tabs (Faculty, Adjunct, etc.)"""
        # Target the specific 'tabNav' class found on your website
        category_links = response.css('ul.tabNav li a::attr(href)').getall()
        
        if not category_links:
            self.logger.warning(f"No category tabs found at {response.url}. Attempting direct profile parse.")
            yield from self.parse_category_page(response)
            return

        for link in category_links:
            # Step 2: Visit each category page (e.g., Adjunct Faculty)
            yield response.follow(link, callback=self.parse_category_page)

    def parse_category_page(self, response):
        """Step 3: Extract the links for every individual faculty member in that category"""
        try:
            # Locate faculty profile links within the 'personalDetails' container
            faculty_links = response.css("div.personalDetails h3 a::attr(href)").getall()
            
            if not faculty_links:
                self.logger.error(f"Could not find faculty links on {response.url}. Check CSS selectors.")
                return

            self.logger.info(f"Found {len(faculty_links)} profiles on {response.url}.")
            
            for link in faculty_links:
                # Step 4: Follow the link to the full individual profile
                yield response.follow(link, callback=self.parse_faculty)
                
        except Exception as e:
            self.logger.error(f"Error parsing category listing at {response.url}: {str(e)}")

    def parse_faculty(self, response):
        """Step 5: Extract all required data from the specific DA-IICT profile layout"""
        try:
            item = FacultyItem()    

            # Profile Image - using urljoin to ensure a complete URL
            img_src = response.css("div.field--name-field-faculty-image img::attr(src)").get()
            item['image_url'] = response.urljoin(img_src) if img_src else "No Image"
            
            # Personal & Professional Identity
            item['name'] = response.css("h1.page-title span::text, div.field--name-field-faculty-names::text").get()
            item['qualification'] = response.css("div.field--name-field-faculty-name.field__item::text").get()
            item['phone'] = response.css("div.field--name-field-contact-no.field__item::text").get()
            
            # Contact Information
            item['address'] = response.css("div.field--name-field-address.field__item::text").getall() 
            item['email'] = response.css("div.field--name-field-email.field__items .field__item::text").getall()
            item['professional_link'] = response.url 
            
            # Bio and Expertise
            item['biography'] = response.css("div.field--name-field-biography.field__item p::text").getall()
            item['specialization'] = response.css("div.work-exp p::text").getall()
            item['publications'] = response.css('div.education ul li ::text').getall()
            item['teaching'] = response.css("div.field--name-field-teaching.field__item li::text").getall()
            item['research'] = response.css("div.field--name-field-faculty-teaching.field__item ::text").getall()

            item['content_hash'] = None
            yield item

        except Exception as e:
            self.logger.error(f"Data extraction failed for profile {response.url}: {str(e)}")
