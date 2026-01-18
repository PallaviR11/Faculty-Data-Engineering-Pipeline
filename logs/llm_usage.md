# LLM Usage Log - Project 1: FacultyFinder

## Ingestion

### Interaction 1

**Date:** 2026-01-11
**Tool:** Gemini
**Prompt:** "i have scraped faculty data from daiict 's website which consists of 66 professors. so will that data be less for my project? should i scrape faculty data of other colleges also."
**Response:** The LLM suggested that 66 records are enough for the engineering phase but recommended 300-500 for better semantic search results in the DS phase.

### Interaction 2

**Date:** 2026-01-11
**Tool:** Gemini
**Prompt:** "data scraped has been saved in excel file. then i have opened it as pandas dataframe. so do i really need to use sqlite?"
**Response:** The LLM clarified that sqlite3 is a mandatory project requirement for "Storage" and "Data Management" scoring (35%).

### Interaction 3

**Date:** 2026-01-11
**Tool:** Gemini
**Prompt:** "this is my spider. how to store this using sqlite"
**Response:** Provided code for a `FacultySqlitePipeline` class to handle schema creation and data insertion, along with instructions to modify `settings.py`.

### Interaction 4

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "correct it as per the pics sent: [Scrapy spider code with image, address, email errors]"
**Response:** The LLM corrected syntax errors in the spider, fixed the misplaced parentheses, and aligned CSS selectors with the website’s HTML structure to properly extract faculty image URLs, names, contact details, and about sections.

### Interaction 5

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "put image url at top of list and generate item list in order"
**Response:** The LLM reorganized the `FacultyItem` fields so that `image_url` appears first, followed by name, qualification, phone, address, email, about, specialization, and teaching fields, ensuring consistent CSV column order.

### Interaction 6

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "give whole code for my spider in this format"
**Response:** The LLM provided a complete, structured Scrapy spider implementing the requested field order and corrected CSS selectors for each data element, including image URLs and text fields.

### Interaction 7

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "i got an empty faculty.csv"
**Response:** The LLM explained that the issue was due to incorrect selectors or running the crawl outside the Scrapy project directory and gave troubleshooting steps to ensure items are yielded properly.

### Interaction 8

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "from this, will i just import field--name and not field--label or field--type?"
**Response:** The LLM confirmed that only the `field--name-*` class is required for CSS selection and that `field--label` and `field--type` are metadata classes that do not affect scraping.

### Interaction 9

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "as i also need to record my chats with llm in llm_usage.md file, summarize our last chats for web scraping in below format"
**Response:** The LLM summarized all recent scraping-related interactions into a structured `llm_usage.md` format suitable for project documentation and audit requirements.

### Interaction 10

**Date:** 2026-01-10
**Tool:** ChatGPT
**Prompt:** "actually i was thinking that instead of manually putting the values of selector, i would create a function which will create selectors automatically for various fields by looking for certain word in class. e.g. select text having class in 'phone/contact' to extract phone no.. because in different sites, the phone no. is mentioned as contact or phone"
**Response:**

### 🛠️ How to do this in Scrapy

You can use **XPath** or **CSS Attribute Selectors** to find elements where the class name *contains* a specific word.

| **Strategy**    | **Logic**                              | **Scrapy Selector Example**                    |
| --------------------- | -------------------------------------------- | ---------------------------------------------------- |
| **Contains**    | Finds any class with "phone" anywhere in it. | `response.xpath("//*[contains(@class, 'phone')]")` |
| **Starts With** | Finds classes starting with "contact".       | `response.css("[class^='contact']")`               |
| **End With**    | Finds classes ending with "bio".             | `response.css("[class$='bio']")`                   |

**Interaction 20**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "should i also include self.conn.commit() in def open_spider(self, spider)"
**Response:** Confirmed that `commit()` is not required for `CREATE TABLE` in this context, but recommended adding a `close_spider` method to properly manage the database connection and prevent locking issues for the API.

**Interaction 24**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "what is recommended for a big data engineering project? to keep the code to replace old data or append at end?"
**Response:** Explained that "Overwriting" (Truncate and Load) is recommended for directory-style projects to maintain a clean, duplicate-free dataset, while "Appending" is reserved for historical or time-series data.

**Interaction 29**

**Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "should all data be inserted in one connection only? can i not add data in multiple connections?"

**Response:** Explained that while multiple connections are technically possible, a single persistent connection is recommended for SQLite to avoid overhead and "Database Locked" errors, ensuring a stable and efficient data pipeline.

**Interaction 30** **Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "so can i say that in pipelines.py, we define a function to open a connection... clean our data and insert... then close the connection"

**Response:** Confirmed the student's summary of the pipeline's lifecycle (Setup, Operation, Cleanup). Verified that this modular approach is a standard engineering practice for ensuring data integrity and preventing resource leaks.

**Interaction 34** **Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "if we don't close the connection will it cause an error like, the database is already in use?"

**Response:** Confirmed that failing to close the connection causes a "Database Lock." Explained that this prevents other spiders or the FastAPI server from accessing the file, emphasizing that `self.conn.close()` is essential for resource management and system stability.

**Interaction 37** **Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "instead of 300 can i write 2?"

**Response:** Confirmed that any number between 0-1000 is valid, but recommended 300 as an industry standard to allow for future pre-processing steps and to maintain professional coding conventions.

**Interaction 40** **Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "how does scrapy know which function to execute once and which function multiple times?"

**Response:** Explained the concept of "Reserved Method Names" and event-driven architecture. Clarified that Scrapy’s engine is pre-programmed to trigger these specific methods at defined stages of the crawl lifecycle.

**Interaction 42** **Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "FEED_EXPORT_ENCODING = 'utf-8' explain"

**Response:** Explained that UTF-8 encoding ensures the correct preservation of special characters and symbols during data export. Highlighted its importance for data integrity and compatibility between the Scrapy database and the FastAPI JSON output.

**Interaction 43**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "is ITEM_PIPELINES used to call facultyscraper pipeline to start data scraping using spider?"
**Response:** Corrected the misconception that the pipeline starts the scraping. Explained that the spider handles the scraping (ingestion), while the `ITEM_PIPELINES` setting activates the processing and storage (persistence) layer.

**Interaction 49** **Date:** 2026-01-13

**Tool:** Gemini

**Prompt:** "so can i say that items.py file tell the spider the format in which it has to extract data?"

**Response:** Confirmed that `items.py` acts as a formal template or schema for the spider. Explained that this ensures data consistency, prevents extraction errors, and maintains compatibility with the database and API layers.

**Interaction 46**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "Can I say that in items.py we define the data structure, the spider creates an instance for each profile, and settings.py calls the pipeline to process and save the data?"
**Response:** Confirmed and refined the user's architectural summary. Explained that `items.py` serves as the schema blueprint and the spider handles instantiation. Clarified that `settings.py` acts as a "switchboard" to enable the pipeline via the `ITEM_PIPELINES` dictionary, which then routes yielded items to `pipelines.py` for cleaning and database storage (persistence).

**Interaction 51**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "so can i say that api_server makes my data saved in database available to other users also over internet in the form of a json file?"
**Response:** Confirmed the user's understanding of the API's role as a data provider. Clarified the distinction between a static file and a dynamic JSON response. Explained that while currently running on `localhost`, the API is designed to serve as a universal bridge, allowing diverse clients (web, mobile, or data tools) to consume the scraped data once deployed.

**Interaction 54**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "Do I only need to make my data available to just my computer as json file or to any device over internet?"

**Response:** Clarified that according to the project specs, the goal is to build a local FastAPI route to facilitate a "hand-off" to a Data Scientist^^. **Confirmed that local JSON serving via the **`<span class="citation-173">/all</span>` endpoint fulfills the requirement and that public internet hosting is not a scored category^^^^^^.

**Interaction 59**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "How does the get_all_faculty() function return the output as a JSON file?"
**Response:** Explained that FastAPI performs automatic serialization, converting Python lists/dictionaries into a JSON string with the appropriate `application/json` headers. **Highlighted that this satisfies the "Serving" requirement of the project by providing a structured hand-off for the Data Scientist**^^^^^^^^.

**Interaction 61**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "What is API and Server?"

**Response:** Defined a Server as the "host" program (Uvicorn/FastAPI) and an API as the "interface" rules that allow data exchange^^^^^^. **Used a restaurant analogy to explain their relationship and highlighted their roles in the "Serving" phase of the Faculty Finder data pipeline**^^.

**Interaction 65**
**Date:** 2026-01-13
**Tool:** Gemini
**Prompt:** "What will happen if I use BeautifulSoup and which folders will I have to change?"
**Response:** Explained that switching to BeautifulSoup would require moving from a modular framework to a single-script architecture. **Highlighted that the user would lose automatic database pipelines **^^and asynchronous processing^^.

**Interaction 95**
**Date:** 2026-01-14
**Tool:** Gemini
**Prompt:** "What value will the spider put in the research field if it is missing?"
**Response:** Explained that `.getall()` returns an empty list `[]` when no matches are found. Clarified that the user's existing pipeline logic will convert this empty list into `None` (SQL NULL) for the database. Suggested a cleaning step to handle whitespace noise when data is present to maximize Data Management scores.
