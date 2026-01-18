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
* **Python 3.10+**
* **curl**: Required for website connectivity checks in the shell script.
  
  **On Ubuntu:**
  ```bash
  sudo apt update && sudo apt install curl -y
  ```
### 2. Clone the Repository
Open your terminal (PowerShell on Windows, or Bash on Linux/macOS) and run:

```bash
git clone https://github.com/PallaviR11/Faculty-Data-Engineering-Pipeline.git
```
```bash
cd Faculty-Data-Engineering-Pipeline
```

### 3. Create a Virtual Environment
It is recommended to use a virtual environment to isolate project dependencies.

**On Windows:**
```bash
python -m venv venv
```
```bash
.\venv\Scripts\Activate.ps1
```
**On Linux (Ubuntu) / macOS:**
```bash
python3 -m venv venv
```
```bash
source venv/bin/activate
```
### 4. Install Required Dependencies
```bash
pip install -r requirements.txt
```
## Running the Pipeline
You can execute the pipeline stage by stage using either Bash (.sh) or PowerShell (.ps1), depending on your operating system.

* ### Running with PowerShell (depipeline.ps1)
  *Windows only*
  
  **Allow script execution (once per session)**
  ```bash
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
  ```
  **Step A: Ingestion (Scraping)**
  Run the Scrapy spider to collect raw faculty data:
  ```bash
  .\depipeline.ps1 ingestion `
    --url https://www.daiict.ac.in/faculty `
    --input raw_data.json
  ```
  **Step B: Transformation**
  Clean the raw JSON data:
  ```bash
  .\depipeline.ps1 transformation `
    --input raw_data.json `
    --output cleaned_data.json
  ```
  **Step C: Storage**
  load the cleaned JSON data into the SQLite database
  ```bash
  .\depipeline.ps1 storage `
    --output cleaned_data.json `
    --db faculty_data.db
  ```
  **Step D: Serving (API)**
  Start the FastAPI server to expose the data:
  ```bash
  .\depipeline.ps1 serving `
    --db faculty_data.db
  ```
* ### Running with Bash (depipeline.sh)
  *Linux / macOS / Git Bash / WSL*
  
  **Allow script execution (first time only)**
  ```bash
  chmod +x depipeline.sh
  ```
  **Step A: Ingestion (Scraping)**
  Run the Scrapy spider to collect raw faculty data:
  ```bash
  ./depipeline.sh ingestion \
    --url https://www.daiict.ac.in/faculty \
    --input raw_data.json
  ```
  **Step B: Transformation**
  Clean the raw JSON data:
  ```bash
  ./depipeline.sh transformation \
    --input raw_data.json \
    --output cleaned_data.json
  ```
  **Step C: Storage**
  load the cleaned JSON data into the SQLite database
  ```bash
  ./depipeline.sh storage \
    --output cleaned_data.json \
    --db faculty_data.db
  ```
  **Step D: Serving (API)**
  Start the FastAPI server to expose the data:
  ```bash
  ./depipeline.sh serving \
    --db faculty_data.db
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
