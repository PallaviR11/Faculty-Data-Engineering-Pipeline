import scrapy

class FacultyItem(scrapy.Item):
    faculty_type = scrapy.Field()
    name = scrapy.Field()
    professional_link = scrapy.Field()
    qualification = scrapy.Field()
    phone = scrapy.Field()
    email = scrapy.Field()
    address = scrapy.Field()
    biography = scrapy.Field()
    specialization = scrapy.Field()
    publications = scrapy.Field()
    teaching = scrapy.Field()
    research = scrapy.Field()
