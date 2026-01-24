# Faculty Data Engineering Pipeline

A complete end-to-end data engineering project designed to scrape faculty information, clean and transform the data, store it in a local database, and serve it via a FastAPI endpoint. This project is built to be cross-platform, running seamlessly on **Windows**, **Linux (Ubuntu)**, and **macOS**.

![Faculty Data Engineering Pipeline ETL Process](pipeline_flow.png)

## Features
* **Automated Scraping:** Uses **Scrapy** to extract faculty details from web sources.
* **Data Transformation:** Cleans raw JSON data into a structured format using Python.
* **Persistent Storage:** Stores processed data in a local **SQLite** database.
* **API Access:** Provides a **FastAPI** server to query and retrieve faculty data via REST endpoints.
* **Cross-Platform Orchestration**: Includes shell scripts (`.sh` for Linux/macOS and `.ps1` for Windows) to automate the entire pipeline.

## Pipeline Execution Flow
The project is structured into four distinct stages:
* **Ingestion:** Scrapy spiders extract raw data from faculty web pages.
* **Transformation:** Python logic cleans and normalizes the raw data.
* **Storage:** The structured data is loaded into a local SQLite database.
* **Serving:** A FastAPI server exposes the data via REST endpoints.

## Project Structure
```text
├── faculty_scraper/          # Scrapy project root
│   ├── __init__.py           # Package initialization
│   ├── spiders/              # Crawler directory
│   │   ├── __init__.py       # Package initialization
│   │   └── faculty_spider.py # Core web scraping logic
│   ├── items.py              # Scraped data containers
│   ├── middlewares.py        # Request/Response processing
│   ├── pipelines.py          # Default (empty) pipelines
│   └── settings.py           # Project configurations
├── logs/                     # Audit logs
│   └── llm_usage.md          # AI interaction records
├── transformation.py         # Cleans raw JSON and removes HTML noise
├── storage.py                # Loads cleaned JSON into SQLite database
├── api_server.py             # FastAPI: Serves processed data via REST endpoints
├── depipeline.sh             # Linux/macOS: Pipeline orchestration script
├── depipeline.ps1            # Windows: Pipeline orchestration script
├── requirements.txt          # Project dependencies
├── scrapy.cfg                # Scrapy configuration
├── pipeline_flow.png         # Visual architecture diagram
├── README.md                 # Project documentation
└── .gitignore                # Excludes local data and virtual environments
```
> Note: Although the project includes a default `pipelines.py` file, the Transformation and Storage stages are implemented as separate standalone scripts (`transformation.py` and `storage.py`).  
> This allows users to run, modify, or debug each stage independently, giving full control over data cleaning and database loading.

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
  *Windows*
  
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
| `/` | `GET` | Root endpoint showing API status |
| `/faculty/all` | `GET` | Returns all faculty members in the database. |
| `/docs` | `GET` | Interactive Swagger UI for testing. |

**Example Response (`/faculty/all`):**
```json
[
  {
    "id": 1,
    "faculty_type": "Faculty",
    "name": "Yash Vasavada",
    "email": "yash_vasavada@dau.ac.in",
    "phone": "079-68261634",
    "professional_link": "https://www.daiict.ac.in/faculty/yash-vasavada",
    "address": "# 1224, FB-1, DA-IICT, Gandhinagar, Gujarat, India – 382007",
    "qualification": "PhD (Electrical Engineering), Virginia Polytechnic Institute and State University, USA",
    "specialization": "Communication, Signal Processing, Machine Learning, Meet Prof. Yash Vasavada:, A Passionate Researcher in Wireless Communications and Signal Processing",
    "teaching": "Introduction to Communication Systems, Advanced Digital Communications, Next Generation Communication Systems",
    "research": "Research not provided",
    "publications": "Yash Vasavada, , Michael Parr, Nidhi Sindhav, and Saumi S., \", A Space-Frequency Processor for Identifying and Isolating GNSS Signals Amidst Interference,, \" IEEE Signal Processing Letters, IEEE, ISSN: 1558-2361, vol. 32, 11 Aug. 2025, pp. 3615-3619, doi: 10.1109/LSP.2025.3598159., B. B. John, A. Dutta and, Y. Vasavada, , \"Unoptimized Reflecting Surfaces for Transmit Index Modulation,\" in IEEE Transactions on Vehicular Technology, doi: 10.1109/TVT.2025.3640006., Y. Vasavada, , A. Dhami and J. H. Reed, \"A Low-Complexity Blind Iterative Approach for Receive-Side Hybrid Beamforming,\" in IEEE Transactions on Communications, April 2024, doi: 10.1109/TCOMM.2024.3388843., https://ieeexplore.ieee.org/document/10499830, Y. Vasavada, , B. B. John, “, Low Complexity Optimal and Suboptimal Detection at Spatial Modulation MIMO Receivers, ,” IEEE Transactions on Vehicular Technology, January 2022, N. Shah,, Y. Vasavada, , “, Neural Layered Decoding of 5G LDPC Codes, ,” IEEE Communications Letters, September 2021, Y. Vasavada, , A. Dhami, J. H. Reed, N. Shah, “Low-Complexity Blind Hybrid Beamforming for mmWave MIMO Reception,” 2022 International Conference on Signal Processing and Communications (SPCOM), 2022, Y. Vasavada, , B. B. John, “Constellation Designs for the Spatial Modulation MIMO Systems for Improved Reliability of the Information Transfer in the Spatial Dimension,” 2022 International Conference on Signal Processing and Communications (SPCOM), 2022, B. B. John,, Y. Vasavada, , “Analysis of the Matched Filter Detector of the Antenna Index in the Spatial Modulation Systems,” 2022 National Conference on Communications (NCC), 1-6, 2022, Y. Vasavada, , N. Parekh, A. Dhami, C. Prakash, “A Blind Iterative Hybrid Analog/Digital Beamformer for the Single User mmWave Reception using a Large Scale Antenna Array,” 2021 National Conference on Communications (NCC), 1-6, 2021, Y. Vasavada, and C. Prakash, “Sub-Nyquist Spectrum Sensing of Sparse Wideband Signals Using Low-Density Measurement Matrices,” in, , IEEE Transactions on Signal Processing, ,, vol. 68, pp. 3723-3737, 2020, doi: 10.1109/TSP.2020.3000637., Y. Vasavada, , C. Ravishankar, and D. Roos,, Correcting satellite pointing direction, ., U.S. Patent, 10,509,097, 2019, Y. Vasavada, , A. A. Beex and J. H. Reed, “Iterative Channel and Symbol Estimation for OFDM and for SIMO Diversity,”, 2018 International Conference on Signal Processing and Communications (, SPCOM, ), , Bangalore, India, pp. 267-271, 2018, doi: 10.1109/SPCOM.2018.8724486., Y. Vasavada, , and C. Prakash, “, An Iterative Message Passing Approach for Compressive Spectrum Sensing, ,” IEEE International Conference on Advances in Computing, Communications and Informatics (, ICACCI, ), 2017., DOI:, 10.1109/ICACCI.2017.8125834, Y. Vasavada, , D. Arur, C. Ravishankar, “, User Location Determination Using Delay and Doppler Measurements in LEO Satellite Systems,, ” IEEE Military Communications Conference (, MILCOM, ), 2017., DOI:, 10.1109/MILCOM.2017.8170797, Y. M. Vasavada, , A. A. L. Beex and J. H. Reed, “, SIMO Diversity Reception in Rayleigh and Rician Fading with Imperfect Channel Estimation, ,” IEEE International Conference on Advances in Computing, Communications and Informatics (ICACCI), 2016., DOI:, 10.1109/ICACCI.2016.7732030, Y. Vasavada, , R. Gopal, C. Ravishankar, G. Zakaria, and N. BenAmmar,, Architectures for Next Generation High Throughput Satellite Systems., , International Journal Satellite Communication Network, , 2016., DOI:, 10.1002/sat.1175",
    "biography": "Yash Vasavada is currently a Professor at DAIICT, and he works in the areas of communication system design and development and application of machine learning algorithms to communications and signal processing. He has over twenty years of experience at Hughes Networks systems in Germantown, Maryland, USA, where he has worked on design, development and deployment of a number of GEO, MEO and LEO satellite systems. At Hughes, Yash has published several journal and conference papers, and he has been granted twelve US Patents. Yash has obtained B. E. degree in Electronics and Communications from L. D. Engineering College, Ahmedabad, and M.S. and Ph.D. degree from Virginia Polytechnic Institute and State University (Virginia Tech) in USA."
  }
]

```
## Data Dictionary

The table below defines the schema for the `Faculty` database and describes the specific transformation logic used to clean "HTML noise" and standardize the data for the API.

| Field | SQLite Type | Description | Cleaning & Transformation Logic |
| :--- | :--- | :--- | :--- |
| **id** | INTEGER | Primary key with auto-increment. | Unique identifier assigned by SQLite upon record insertion. |
| **faculty_type** | TEXT | Classification of the faculty member. | Extracted from the source listing URL and standardized to Title Case. |
| **name** | TEXT | Full name of the faculty member. | Converted to Title Case (e.g., "YASH VASAVADA" to "Yash Vasavada"). |
| **email** | TEXT | Professional email address(es). | Flattened from raw list fragments into a comma-separated string. |
| **phone** | TEXT | Official contact number(s). | Flattened into a unified string; whitespace normalized. |
| **professional_link** | TEXT | Source URL to the individual profile. | Captured as a direct reference to the origin data. |
| **address** | TEXT | Official campus or office address. | Normalized whitespace and stripped leading/trailing commas to remove **HTML noise**. |
| **qualification** | TEXT | Educational background and degrees. | Joined list fragments with a " &#124; " pipe delimiter for readability. |
| **specialization** | TEXT | Areas of professional expertise. | Cleaned of leading/trailing commas and **HTML noise**; joined into a clean string. |
| **teaching** | TEXT | List of courses taught. | Newline-separated for proper display in the API response. |
| **research** | TEXT | Current research interests/projects. | Populated with **"Research not provided"** fallback if source data is missing. |
| **publications** | TEXT | Academic citations and papers. | Intensive cleaning to collapse whitespace and remove **HTML noise/fragments**. |
| **biography** | TEXT | Professional summary/biography. | Joined multiple paragraph fragments into a single continuous block. |

## Data Transformation

- Validates raw JSON input existence.  
- Flattens list-type fields into strings.  
- Normalizes text and removes HTML noise.  
- Handles missing values:  
  - Placeholder text for content-related fields.  
  - null for other fields.  
- Standardizes fields:  
  - Names → Title Case.  
  - Faculty type → hyphens replaced by spaces, Title Case.  
- Writes output to cleaned_data.json.  

## Data Storage

The storage stage persists the cleaned faculty data into a relational SQLite database.

- Validates cleaned JSON input.  
- Initializes SQLite database and creates `Faculty` table if missing.  
- Loads cleaned data using batch `INSERT OR IGNORE` for efficiency.  
- Commits all inserts in a single transaction to ensure consistency.  

## Dependencies

- Scrapy – Web scraping and crawling.  
- Requests – Auxiliary HTTP requests.  
- FastAPI – REST API server.  
- Uvicorn – ASGI server for FastAPI.  
- Pydantic – Data validation and schema enforcement.  

## Pipeline Orchestration Scripts

- depipeline.ps1 (Windows / PowerShell)  
- depipeline.sh (Linux / macOS / Bash)  

### Supported Stages:

- ingestion – Scrapy spider to fetch raw JSON.  
- transformation – Clean and normalize data (transformation.py).  
- storage – Load into SQLite (storage.py).  
- serving – Start FastAPI application.  

This separation allows users to run, modify, or debug each stage independently.  

## Future Enhancements

- Cross-Institutional Scalability: Generalize parsing for multiple universities.  
- Advanced Search & Filtering: Enable queries by department, research, or ranking.  
- Analytical Dashboard: Visualize faculty trends using Streamlit or React.  
- Automated Sync & Change Detection: Schedule periodic crawls with GitHub Actions or Cron. 
