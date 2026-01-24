# **LLM Usage Log – Project 1: FacultyFinder**

---

## **Interaction 1**
**Tool:** ChatGPT  
**Prompt:**  
“Since I manually created my spider and did not use genspider, should I remove or comment out SPIDER_MODULES and NEWSPIDER_MODULE from settings.py?"

**Response:**  
The LLM explained that SPIDER_MODULES is mandatory for Scrapy to locate spider files during crawling, regardless of whether genspider is used. It also clarified that NEWSPIDER_MODULE is only used when generating new spiders via genspider and does not affect existing spiders. The LLM recommended keeping both settings as per standard Scrapy project structure, even if spiders are written manually.

---

## **Interaction 2**
**Tool:** Gemini  
**Prompt:**  
"how does scrapy know which function to execute once and which function multiple times?"

**Response:**  
Explained the concept of "Reserved Method Names" and event-driven architecture. Clarified that Scrapy’s engine is pre-programmed to trigger these specific methods at defined stages of the crawl lifecycle.

---

## **Interaction 3**
**Tool:** ChatGPT  
**Prompt:**  
"I am trying to scrape faculty data using Scrapy, but my spider is running and still returning an empty output file. What could be the issue?"

**Response:**  
If the spider runs but the output file is empty, the most common reasons are incorrect CSS selectors, JavaScript-rendered content, or the parse method not yielding items correctly. First, verify your selectors using Scrapy Shell and ensure yield item is being called.

---

## **Interaction 4**
**Tool:** ChatGPT  
**Prompt:**  
"I checked all my selectors in the browser and Scrapy shell. They seem correct. Still, nothing is getting saved."

**Response:**  
In that case, check whether your spider is actually reaching the parse_faculty callback. Sometimes profile links are incorrect or relative URLs are not being followed properly. Also verify that your start_urls page contains the expected anchor tags.

---

## **Interaction 5**
**Tool:** ChatGPT  
**Prompt:**  
"My Scrapy crawl command gives an empty CSV or 'no active project' error. How do I fix this and ensure my spider executes properly?"

**Response:**  
The LLM identified that the error occurs when the crawl command is run outside the Scrapy project root or when SPIDER_MODULES is misconfigured. It explained the correct project directory structure, confirmed the importance of running the command from the project root, and provided guidance on validating selectors and ensuring items are yielded so data is written correctly to the output file.

---

## **Interaction 6**
**Tool:** ChatGPT  
**Prompt:**  
"I noticed this selector:  
`.field--name-field-email .field__item`  
Why is there a space between email and .field__item?"

**Response:**  
The space means a descendant selector. It selects .field__item elements that are inside an element with class .field--name-field-email. Without the space, Scrapy would look for a single element having both classes, which doesn’t match the HTML structure.

---

## **Interaction 7**
**Tool:** ChatGPT  
**Prompt:**  
"Using a single IP address, how many pages can I request access to without getting blocked?"

**Response:**  
There is no fixed number of pages that guarantees you won’t be blocked. Websites usually monitor request rate, concurrency, and access patterns rather than total page count. For most academic or public websites, sending one request every few seconds with limited concurrency is considered safe and unlikely to trigger blocking.

---

## **Interaction 8**
**Tool:** ChatGPT  
**Prompt:**  
"With a 1-second delay and one request at a time, shouldn’t the total crawl time be 67 × 2 seconds?"

**Response:**  
No. Scrapy enforces a minimum gap between request start times, not “download time + delay.” The effective time per request is max(download_time, DOWNLOAD_DELAY). Since the pages load quickly, your total crawl time would be closer to ~60–80 seconds.

---

## **Interaction 9**
**Tool:** ChatGPT  
**Prompt:**  
"While storing faculty data in the database, should I clean or remove special characters from the faculty names? Since the data is scraped from an official university website, the names will certainly always be correct."

**Response:**  
The LLM advised that faculty names from official university websites are typically accurate and should not undergo aggressive cleaning. It recommended only light normalization such as trimming whitespace, handling encoding issues, and collapsing multiple spaces. The LLM cautioned against removing punctuation or special characters like periods, hyphens, or apostrophes, as these are valid parts of real names. This approach preserves data integrity while maintaining consistency for downstream analysis.

---

## **Interaction 10**
**Tool:** Gemini  
**Prompt:**  
"should all data be inserted in one connection only? can i not add data in multiple connections?"

**Response:**  
Explained that while multiple connections are technically possible, a single persistent connection is recommended for SQLite to avoid overhead and "Database Locked" errors, ensuring a stable and efficient data pipeline.

---

## **Interaction 11**
**Tool:** Gemini  
**Prompt:**  
"what is recommended? to keep the code to replace old data or append at end?"

**Response:**  
Explained that "Overwriting" (Truncate and Load) is recommended for directory-style projects to maintain a clean, duplicate-free dataset, while "Appending" is reserved for historical or time-series data.

---

## **Interaction 12**
**Tool:** Gemini  
**Prompt:**  
"instead of 300 can i write 2 for in `faculty_scraper.pipelines.FacultyScraperPipeline`: 300?"

**Response:**  
Confirmed that any number between 0–1000 is valid, but recommended 300 as an industry standard to allow for future pre-processing steps and to maintain professional coding conventions.

---

## **Interaction 13**
**Tool:** Gemini  
**Prompt:**  
"What value will the spider put in the research field if it is missing?"

**Response:**  
Explained that `.getall()` returns an empty list `[]` when no matches are found. Clarified that the transformation logic will convert this into `None` (SQL NULL) for the database.

---

## **Interaction 14**  *(Late-stage architectural comparison)*
**Tool:** Gemini  
**Prompt:**  
"What will happen if I use BeautifulSoup and which folders will I have to change?"

**Response:**  
Explained that switching to BeautifulSoup would require moving from a modular framework to a single-script architecture. Highlighted that the user would lose automatic database pipelines and asynchronous processing.

## Ethical Compliance Statement
All code provided by the LLMs was manually reviewed, debugged, and tested across local Windows and Ubuntu environments. The AI served as a collaborative assistant to optimize documentation and provide architectural suggestions for the data engineering lifecycle.

