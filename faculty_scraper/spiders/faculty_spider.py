import scrapy
from ..items import FacultyItem

class FacultySpider(scrapy.Spider):
    name = "faculty_spider"
    
    def __init__(self, start_url=None, *args, **kwargs):
        super(FacultySpider, self).__init__(*args, **kwargs)
        if not start_url:
            raise ValueError("No start_url provided! Usage: scrapy crawl faculty_spider -a start_url='URL'")
        self.start_urls = [start_url]

    def parse(self, response):
        """Step 1: Follow all 4 category links (Faculty, Adjunct, etc.)"""
        category_links = response.css('ul.tabNav li a::attr(href)').getall()
        
        if category_links:
            for link in category_links:
                # dont_filter=True ensures we don't skip categories that share a base URL
                yield response.follow(link, callback=self.parse_category_page, dont_filter=True)
        else:
            yield from self.parse_category_page(response)

    def parse_category_page(self, response):
        """Step 2: Scrape profiles AND handle pagination (Next buttons)"""
        # 1. Extract individual profile links on the current page
        faculty_links = response.css("div.personalDetails h3 a::attr(href)").getall()
        for link in faculty_links:
            yield response.follow(link, callback=self.parse_faculty)

        # 2. Pagination Logic: Find the 'Next' page link if it exists
        # Common Drupal/Website 'Next' button selectors
        next_page = response.css('li.pager__item--next a::attr(href), li.next a::attr(href)').get()
        if next_page:
            self.logger.info(f"Moving to next page: {next_page}")
            yield response.follow(next_page, callback=self.parse_category_page)

    def parse_faculty(self, response):
        """Step 3: Extract the detailed profile data"""
        try:
            item = FacultyItem()
            
            # Identify the category for data organization
            # This helps you verify which list the profile came from
            img_src = response.css("div.field--name-field-faculty-image img::attr(src)").get()
            item['image_url'] = response.urljoin(img_src) if img_src else "No Image"
            
            item['name'] = response.css("h1.page-title span::text, div.field--name-field-faculty-names::text").get()
            item['qualification'] = response.css("div.field--name-field-faculty-name.field__item::text").get()
            item['phone'] = response.css("div.field--name-field-contact-no.field__item::text").get()
            
            item['address'] = response.css("div.field--name-field-address.field__item::text").getall() 
            item['email'] = response.css("div.field--name-field-email.field__items .field__item::text").getall()
            item['professional_link'] = response.url 
            
            item['biography'] = response.css("div.field--name-field-biography.field__item p::text").getall()
            item['specialization'] = response.css("div.work-exp p::text").getall()
            item['publications'] = response.css('div.education ul li ::text').getall()
            item['teaching'] = response.css("div.field--name-field-teaching.field__item li::text").getall()
            item['research'] = response.css("div.field--name-field-faculty-teaching.field__item ::text").getall()

            item['content_hash'] = None
            yield item

        except Exception as e:
            self.logger.error(f"Failed to extract {response.url}: {str(e)}")
