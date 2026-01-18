# Faculty Data Engineering Pipeline

A complete end-to-end data engineering project designed to scrape faculty information, clean and transform the data, store it in a local database, and serve it via a FastAPI endpoint. This project is built to be cross-platform, running seamlessly on **Windows**, **Linux (Ubuntu)**, and **macOS**.

![Faculty Data Engineering Pipeline ETL Process](pipeline_flow.png)

## Features
* **Automated Scraping:** Uses **Scrapy** to extract faculty details from web sources.
* **Data Transformation:** Cleans raw JSON data into a structured format using Python.
* **Persistent Storage:** Stores processed data in a local **SQLite** database.
* **API Access:** Provides a **FastAPI** server to query and retrieve faculty data via REST endpoints.
* **Cross-Platform Orchestration**: Includes shell scripts (`.sh` for Linux/macOS and `.ps1` for Windows) to automate the entire pipeline.

## Project Structure
```text
├── faculty_scraper/     # Scrapy project folder (Spider logic)
├── transformation.py    # Data cleaning and transformation script
├── storage.py           # SQLite database management logic
├── api_server.py        # FastAPI server implementation
├── depipeline.sh        # Linux/macOS Bash orchestration script
├── depipeline.ps1       # Windows PowerShell orchestration script
├── requirements.txt     # Project dependencies
├── scrapy.cfg           # Scrapy configuration file (Essential for execution)
└── .gitignore           # Configuration to exclude local data and environments
```

## Pipeline Execution Flow
The project is structured into four distinct stages:
* **Ingestion:** Scrapy spiders extract raw data from faculty web pages.
* **Transformation:** Python logic cleans and normalizes the raw data.
* **Storage:** The structured data is loaded into a local SQLite database.
* **Serving:** A FastAPI server exposes the data via REST endpoints.

## Installation & Setup
Follow these steps to set up the Faculty Data Engineering Pipeline on your local machine.
### 1. Prerequisites
Ensure you have **Python 3.10+** installed on your system.
### 2. Clone the Repository
Open your terminal (PowerShell on Windows, or Bash on Linux/macOS) and run:

```bash
git clone [https://github.com/PallaviR11/Faculty-Data-Engineering-Pipeline.git](https://github.com/PallaviR11/Faculty-Data-Engineering-Pipeline.git)
cd Faculty-Data-Engineering-Pipeline
```

### 3. Create a Virtual Environment
It is recommended to use a virtual environment to isolate project dependencies.
**On Windows:**
'''bash
python -m venv venv
.\venv\Scripts\Activate.ps1
'''
**On Linux (Ubuntu) / macOS:**
'''bash
python3 -m venv venv
'''
### 4. Install Required Dependencies
```bash
pip install -r requirements.txt
```
source venv/bin/activate

## Running the Pipeline
You can run the **Faculty Data Engineering Pipeline** either as a single automated process or by executing each stage manually for development and testing.

### 1. Automated Execution (Recommended)
### 1. Automated Execution (Recommended)
The orchestration scripts automate the entire ETL flow (**Ingestion** -> **Transformation** -> **Storage**) in a single command.

* **On Windows (PowerShell):**
    ```powershell
    ./depipeline.ps1
    ```
   

* **On Linux (Ubuntu) / macOS:**
    ```bash
    chmod +x depipeline.sh && ./depipeline.sh
    ```
Once the data is processed, launch the **FastAPI** server to begin serving the data:
```bash
uvicorn api_server:app --reload
```

### 2. Manual Stage-by-Stage Execution
If you need to debug a specific part of the pipeline, you can run the stages individually.

**Step A: Ingestion (Scraping)**
Run the Scrapy spider to collect raw faculty data:
```bash
cd faculty_scraper
scrapy crawl faculty_spider -o raw_data.json
```
**Step B: Transformation & Storage**
Clean the raw JSON data and load it into the SQLite database:
```bash
python transformation.py
```
**Step C: Serving (API)**
Start the FastAPI server to expose the data:
```bash
uvicorn api_server:app --reload
```

## API Documentation
Once the server is running, you can access the following endpoints:

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/` | `GET` | Root endpoint showing API status and welcome message. |
| `/faculty/all` | `GET` | Returns a list of all scraped faculty members in the database. |
| `/docs` | `GET` | Interactive Swagger UI documentation for testing endpoints. |

**Example Response (`/faculty/all`):**
```json
[
  {
    "name": "Dr. John Doe",
    "department": "Computer Science",
    "email": "jdoe@university.edu"
  }
]
```

## Linux Permissions
Ensure the Bash script is executable if the automated command fails:
```bash
chmod +x depipeline.sh
```
## Database Lock
If the database remains empty, ensure your transformation.py has finished processing the raw_data.json file completely before starting the API.
