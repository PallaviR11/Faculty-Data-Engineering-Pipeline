import scrapy

class FacultyItem(scrapy.Item):
    image_url = scrapy.Field()
    name = scrapy.Field()
    qualification = scrapy.Field()
    phone = scrapy.Field()
    address = scrapy.Field()
    email = scrapy.Field()
    professional_link = scrapy.Field()
    biography = scrapy.Field()
    specialization = scrapy.Field()
    publications = scrapy.Field()
    teaching = scrapy.Field()
    research = scrapy.Field()
    content_hash = scrapy.Field()
