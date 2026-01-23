import scrapy

class FacultyItem(scrapy.Item):
    # Identity
    faculty_type = scrapy.Field()
    name = scrapy.Field()

    # Contact information
    email = scrapy.Field()
    phone = scrapy.Field()
    professional_link = scrapy.Field()
    address = scrapy.Field()

    # Academic profile
    qualification = scrapy.Field()
    specialization = scrapy.Field()
    teaching = scrapy.Field()
    research = scrapy.Field()
    publications = scrapy.Field()

    # Long free-text
    biography = scrapy.Field()
