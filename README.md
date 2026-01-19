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
    "image_url": "https://www.daiict.ac.in/sites/default/files/faculty_image/SUJAY_KADAM.jpg",
    "name": "Sujay Kadam",
    "qualification": "PhD (Electrical Engineering), IIT Gandhinagar",
    "phone": "07968261584",
    "address": "# 1210, FB-1, DA-IICT, Gandhinagar, Gujarat, India – 382007",
    "email": "sujay_kadam@dau.ac.in",
    "professional_link": "https://www.daiict.ac.in/faculty/sujay-kadam",
    "biography": "Sujay Kadam is an Assistant Professor in DA-IICT. Prior to his joining at DA-IICT he was a faculty member in the Department of Electrical and Electronics Engineering, NIT Sikkim. NIT Sikkim. He was a Post-Doctoral Fellow in Mechanical Engineering, working with Prof. Harish Palanthandalam-Madapusi, and was associated with the SysIDEA Robotics Lab at IIT Gandhinagar, prior to his teaching appointments, where he worked on ‘learning controllers that show ‘human-like’ learning characteristics. He completed his doctoral work in control theory with a thesis on “Right Invertibility and Relative Degree in Tracking Control: Theory and Tools”, under the supervision of Prof. Harish Palanthandalam-Madapusi at IIT Gandhinagar in Electrical Engineering. He has a background in Instrumentation and Control from his bachelor’s and master’s degrees. His current work and interests focus on the intersecting areas of Control, Neuroscience, and Robotics.,
    "specialization": "Instrumentation, Systems and Control Theory, Human-Motor Learning, Robotics",
    "publications": "Kadam, S.D.,, Chavan, R.A., Rajiv, A. and Palanthandalam-Madapusi, H.J., 2019. “, A Perspective on using Input Reconstruction for Command Following, ”., Circuits, Systems, and Signal Processing,, 38(12), pp. 5920-5930., Kadam, S.D., and Palanthandalam-Madapusi, H.J., 2018, “, Trackability for Discrete-Time Linear Time-Invariant Systems: A Brief Review and New Insights, ”., ASME Journal of Dynamical Systems, Measurement & Control,, (March 2022; 144(3): (031007), ASME., Kadam, S.D., and Palanthandalam-Madapusi, H.J., 2022, “, A Note on Invertibility and Relative Degree of MIMO LTI Systems, ”., IFAC Journal of Systems and Control,, 100193., Kadam, S.D., , Jadav S., and Palanthandalam-Madapusi, H.J., 2022, “A Model-based Feedforward and Iterative Learning Controller Exhibiting Features of Human Motor Learning”., IEEE Transactions on Cognitive and, Developmental Systems: Special Issue-Emerging Topics on Development and Learning, (under review since January 31st, 2022), Riswadkar, S., Kakadiya J.,, Kadam, S.D.,, Sidhu K., and Palanthandalam-Madapusi, H.J., 2020, “, Swirling Pendulum Dynamics and Control: A Pedagogical Perspective, ”,, American, Control, Conference, (ACC),, 2022, (pp. 5093-5098). IEEE., Rao, A.,, Kadam, S.D., and Palanthandalam-Madapusi, H.J., 2020, “, A Perspective on Prioritized Tracking Control for Systems with More Outputs than Inputs, ”, In Advances in Robotics (AIR), 2021 June (https://doi.org/10.1145/3478586.3478596), ACM., Kadam, S.D.,, Shah, U., D’Souza, A., Prajwal, G. S., Raj, N., Banavar, R. N., and Palanthandalam-Madapusi, H.J., 2020, October. “, The Swirling Pendulum: Conceptualization, Modeling, Equilibria, and Control Synthesis, ”. In, Dynamic Systems and Control Conference 2020 Oct 5, (Vol. 84270, p. V001T16A002), ASME., Kadam, S.D.,, Rao, A., Prusty B. and Palanthandalam-Madapusi, H.J., 2020, “, Selective Tracking Using Linear Trackability Analysis and Inversion-based Tracking Control, ”. In, 2020 American Control Conference (ACC), (pp. 5346-5351), IEEE., Kadam, S.D., and Palanthandalam-Madapusi, H.J., 2017, May. “, Revisiting Trackability for Linear Time-Invariant Systems, ”. In, American, Control, Conference, (ACC),, 2017, (pp. 1728-1733). IEEE., Kadam, S. D.,, and Kunal N. Tiwari. “A Simplified Approach to tune PD Controller for Depth Control of an Autonomous Underwater Vehicle.” In proceedings of the, National Conference on Communication, Computing, and Networking Technologies,, pp. 209-212. 2013., Kadam, S.D., and Waghmare, L.M., 2013, August. “, Control of Integrating Processes with Dead-Time using PID Controllers with Disturbance Observer-based Smith Predictor, .” In, IEEE International Conference on Control, Applications (CCA) - part of IEEE MSC 2013 (, pp. 1265-1269). IEEE., Kadam, S. D., & Palanthandalam-Madapusi, H. J. (2020). “, Trackability for Discrete-Time LTI Systems: A Brief Review and New Insights, ”. arXiv preprint arXiv:2006.09228., Kadam, S.D.,, 2019. “, An I+ PI Controller Structure for Integrating Processes with Dead-Time: Application to Depth Control of an Autonomous Underwater Vehicle, ”. arXiv preprint arXiv:1908.09250., Kadam, S.D.,, 2017. “, Disturbance Observer-based Control of Integrating Processes with Dead-Time using PD controller., ” arXiv preprint arXiv: 1711.11250.",
    "teaching": "ME 491A:, – as a Graduate Teaching Fellow at IIT Gandhinagar, EE13102: Analog Electronic Circuits and Systems – at NIT Sikkim, EE13104: Digital Electronics – at NIT Sikkim, EE14104/EC14105/CS14106: Microprocessors and Microcontrollers – at NIT Sikkim, EE17150: Introduction to Internet of Things – at NIT Sikkim, EE431: Electrical Systems Lab (Teaching Assistant, multiple semesters) – at IIT Gandhinagar, ME639: Introduction to Robotics (Teaching Assistant) – at IIT Gandhinagar, ES105: Electrical and Electronics Lab (Teaching Assistant, multiple semesters) – at IIT Gandhinagar",
    "research": "Robotics, Control Theory, Autonomous Ground and Underwater Vehicles, Human Motor Learning, Learning Controllers, Subspace State-Space System Identification"
  },
```
