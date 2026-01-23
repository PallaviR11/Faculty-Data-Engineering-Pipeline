import scrapy
from ..items import FacultyItem

class FacultySpider(scrapy.Spider):
    name = "faculty_spider"
    allowed_domains = ["daiict.ac.in"]
    
    start_urls = [
        "https://www.daiict.ac.in/faculty",
        "https://www.daiict.ac.in/adjunct-faculty",
        "https://www.daiict.ac.in/adjunct-faculty-international",
        "https://www.daiict.ac.in/distinguished-professor",
        "https://www.daiict.ac.in/professor-practice"
    ]

    def clean_list(self, values):
        """Helper to remove empty strings and whitespace from list of strings"""
        return [v.strip() for v in values if v and v.strip()]

    def parse(self, response):
        """
        Parse the main faculty listing pages
        """
        # Select the list items containing faculty info
        faculty_cards = response.css("div.facultyInformation ul li")

        for faculty in faculty_cards:
            # Combined selector to handle different class name variations on the site
            profile_link = faculty.css(
                "div.personalDetails h3 a::attr(href), "
                "div.personalDetail h3 a::attr(href), "
                "div.personalsDetails h3 a::attr(href)"
            ).get()

            name = faculty.css(
                "div.personalDetails h3 a::text, "
                "div.personalDetail h3 a::text, "
                "div.personalsDetails h3 a::text"
            ).get()

            if profile_link:
                yield response.follow(
                    profile_link,
                    callback=self.parse_faculty_profile,
                    meta={
                        "name": name.strip() if name else "Unknown", 
                        "profile_url": response.urljoin(profile_link)
                    }
                )

    def parse_faculty_profile(self, response):
        """Tier 2: Extract specific professional fields"""
        item = FacultyItem()
        
        # Meta and Basic Identity
        item['faculty_type'] = response.meta.get('faculty_type')
        item['name'] = response.css("div.field--name-field-faculty-names.field__item::text").get()
        item['professional_link'] = response.url 
        
        # Professional Attributes
        item['qualification'] = response.css("div.field--name-field-faculty-name.field__item::text").get()
        item['phone'] = response.css("div.field--name-field-contact-no.field__item::text").get()
        item['email'] = response.css("div.field--name-field-email.field__items .field__item::text").getall()
        item['address'] = response.css("div.field--name-field-address.field__item::text").getall() 
            
        # Detailed Professional Content
        item['biography'] = response.css("div.field--name-field-biography.field__item p::text").getall()
        item['specialization'] = response.css("div.work-exp p::text").getall()
        item['publications'] = response.css('div.education ul li ::text').getall()
        item['teaching'] = response.css("div.field--name-field-teaching.field__item li::text").getall()
        item['research'] = response.css("div.field--name-field-faculty-teaching.field__item ::text").getall()

        yield item
