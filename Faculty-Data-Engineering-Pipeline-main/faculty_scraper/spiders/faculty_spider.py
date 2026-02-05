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

    def parse(self, response):
        """
        Parse the main faculty listing pages
        """
        # 1. Determine the type of each page
        raw_type = response.url.strip('/').split('/')[-1].replace("-", " ").title()

        # 2. Select the faculty cards
        faculty_cards = response.css("div.facultyInformation ul li")

        for faculty in faculty_cards:
            # 3. Extract basic info from the card
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
                # 4. Pass EVERYTHING to the next stage in one meta backpack
                yield response.follow(
                    profile_link,
                    callback=self.parse_faculty_profile,
                    meta={
                        "name": name.strip() if name else "Unknown",
                        "faculty_type": raw_type
                    }
                )

    def parse_faculty_profile(self, response):
        """Tier 2: Extract specific professional fields"""
        item = FacultyItem()
        
        # Identity
        item['faculty_type'] = response.meta.get('faculty_type')
        item['name'] = response.css("div.field--name-field-faculty-names.field__item::text").get()

        # Contact information
        item['email'] = response.css("div.field--name-field-email.field__items .field__item::text").getall()
        item['phone'] = response.css("div.field--name-field-contact-no.field__item::text").getall()
        item['professional_link'] = response.url
        item['address'] = response.css("div.field--name-field-address.field__item::text").getall()

        # Academic profile
        item['qualification'] = response.css("div.field--name-field-faculty-name.field__item::text").get()
        item['specialization'] = response.css("div.work-exp p ::text").getall()
        item['teaching'] = response.css("div.field--name-field-teaching.field__item li::text").getall()
        item['research'] = response.css("div.field--name-field-faculty-teaching.field__item ::text").getall()

        # Long free-text
        item['publications'] = response.css("div.education ul li ::text").getall()
        item['biography'] = response.css("div.field--name-field-biography.field__item p::text").getall()

        yield item

