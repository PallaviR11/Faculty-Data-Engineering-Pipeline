import scrapy
from ..items import FacultyItem

class FacultySpider(scrapy.Spider):
    name = "faculty_spider"
    
    def __init__(self, start_url=None, *args, **kwargs):
        super(FacultySpider, self).__init__(*args, **kwargs)
        # Default to the main faculty page if no start_url is provided
        self.start_urls = [start_url] if start_url else ["https://www.daiict.ac.in/faculty"]

    def parse(self, response):
        """Step 1: Find all category links (Faculty, Adjunct, etc.)"""
        # The 'tabNav' class contains the links for the different faculty types.
        category_links = response.css('ul.tabNav li a::attr(href)').getall()
        
        if not category_links:
            self.logger.error(f"No category links found at {response.url}. Check 'ul.tabNav' selector.")
            # Fallback: try to parse the current page directly if no tabs are found
            yield from self.parse_category_page(response)
            return

        for link in category_links:
            # Step 2: Follow each category link (e.g., /adjunct-faculty)
            yield response.follow(link, callback=self.parse_category_page)

    def parse_category_page(self, response):
        """Step 3: Extract individual profile links from a category page"""
        try:
            # Each faculty card is usually inside 'personalDetails' or similar.
            faculty_links = response.css("div.personalDetails h3 a::attr(href)").getall()
            
            if not faculty_links:
                self.logger.warning(f"No faculty profiles found on category page: {response.url}")
                return

            self.logger.info(f"Found {len(faculty_links)} profiles on {response.url}")
            
            for link in faculty_links:
                # Step 4: Follow the deep link to the actual faculty profile
                yield response.follow(link, callback=self.parse_faculty)
                
        except Exception as e:
            self.logger.error(f"Failed to parse category page {response.url}: {str(e)}")

    def parse_faculty(self, response):
        """Step 5: Extract specific entities from the individual profile page"""
        try:
            item = FacultyItem()    

            # Basic Info - Using more robust selectors based on standard Drupal structures
            img_src = response.css("div.field--name-field-faculty-image img::attr(src)").get()
            item['image_url'] = response.urljoin(img_src) if img_src else "No Image"
            
            # The name is often in the page title or a specific field.
            item['name'] = response.css("h1.page-title span::text, div.field--name-field-faculty-names::text").get()
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
