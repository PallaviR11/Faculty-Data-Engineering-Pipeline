# # COLORS
# $CYAN    = "$([char]27)[0;36m"
# $ORANGE  = "$([char]27)[38;5;178m"
# $YELLOW  = "$([char]27)[38;5;226m"
# $MAGENTA = "$([char]27)[38;5;207m"
# $GREEN   = "$([char]27)[38;5;118m"
# $RED     = "$([char]27)[0;31m"
# $NC      = "$([char]27)[0m"

# # STAGE INPUT
# $STAGE = Read-Host "${ORANGE}Enter pipeline stage (ingestion / transformation / storage / serving)${NC}"

# # DEFAULT FILE NAMES
# $RAW_FILE    = "raw_data.json"
# $CLEAN_FILE  = "cleaned_data.json"
# $DB_NAME     = "faculty_data.db"
# $EXPORT_JSON = "exported_data.json"

# switch ($STAGE) {

#     "ingestion" {
#         $READ_URL = Read-Host "${CYAN}Enter READ URL for ingestion${NC}"
#         if ($READ_URL -notlike "http*") {
#             Write-Host "${RED}Error: URL must start with 'http://' or 'https://'.${NC}"
#             exit 1
#         }

#         Write-Host "${CYAN}Checking website connectivity...${NC}"
#         try {
#             $response = Invoke-WebRequest -Uri $READ_URL -Method Head -ErrorAction Stop
#             Write-Host "${GREEN}Website reachable (Status: $($response.StatusCode)).${NC}"
#         } catch {
#             Write-Host "${RED}Error: Cannot reach $READ_URL.${NC}"
#             exit 1
#         }

#         $RAW_FILE = Read-Host "${CYAN}Enter RAW file name (press Enter for default: raw_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($RAW_FILE)) { $RAW_FILE = "raw_data.json" }

#         if ($RAW_FILE -notlike "*.json") {
#             Write-Host "${RED}Error: RAW file must have a .json extension.${NC}"
#             exit 1
#         }

#         Write-Host "${CYAN}DEPipeline Stage 1: Ingestion Starting...${NC}"
#         $env:PYTHONPATH += ";."
#         python -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

#         if (!(Test-Path $RAW_FILE)) {
#             Write-Host "${RED}Error: Output file '$RAW_FILE' not created.${NC}"
#             exit 1
#         }

#         $recordCount = (Get-Content $RAW_FILE | Where-Object { $_.Trim() -ne "" }).Count
#         Write-Host "${CYAN}Ingestion completed. Records: $recordCount | Saved: $RAW_FILE${NC}"
#     }

#     "transformation" {
#         $RAW_FILE = Read-Host "${YELLOW}Enter RAW file name (press Enter for default: raw_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($RAW_FILE)) { $RAW_FILE = "raw_data.json" }

#         if ($RAW_FILE -notlike "*.json" -or !(Test-Path $RAW_FILE)) {
#             Write-Host "${RED}Error: Valid .json RAW file not found.${NC}"
#             exit 1
#         }

#         $CLEAN_FILE = Read-Host "${YELLOW}Enter CLEAN file name (press Enter for default: cleaned_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($CLEAN_FILE)) { $CLEAN_FILE = "cleaned_data.json" }

#         if ($CLEAN_FILE -notlike "*.json") {
#             Write-Host "${RED}Error: Output CLEAN file must have a .json extension.${NC}"
#             exit 1
#         }

#         Write-Host "${YELLOW}Stage 2: Transforming $RAW_FILE -> $CLEAN_FILE...${NC}"
#         python transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"
#     }

#     "storage" {
#         $CLEAN_FILE = Read-Host "${MAGENTA}Enter CLEANED file name (press Enter for default: cleaned_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($CLEAN_FILE)) { $CLEAN_FILE = "cleaned_data.json" }

#         if ($CLEAN_FILE -notlike "*.json" -or !(Test-Path $CLEAN_FILE)) {
#             Write-Host "${RED}Error: Valid .json file not found.${NC}"
#             exit 1
#         }

#         $DB_NAME = Read-Host "${MAGENTA}Enter Database name (press Enter for default: faculty_data.db)${NC}"
#         if ([string]::IsNullOrWhiteSpace($DB_NAME)) { $DB_NAME = "faculty_data.db" }

#         if ($DB_NAME -notlike "*.db") {
#             Write-Host "${RED}Error: Database file must have a .db extension.${NC}"
#             exit 1
#         }

#         Write-Host "${MAGENTA}Stage 3: Loading $CLEAN_FILE into $DB_NAME...${NC}"
#         python storage.py --input "$CLEAN_FILE" --database "$DB_NAME"
#     }

#     "serving" {
#         $DB_NAME = Read-Host "${GREEN}Enter Database name (press Enter for default: faculty_data.db)${NC}"
#         if ([string]::IsNullOrWhiteSpace($DB_NAME)) { $DB_NAME = "faculty_data.db" }

#         if ($DB_NAME -notlike "*.db" -or !(Test-Path $DB_NAME)) {
#             Write-Host "${RED}Error: Database '$DB_NAME' not found or invalid extension.${NC}"
#             exit 1
#         }

#         # NEW: Input for JSON file to be created during serving
#         $EXPORT_JSON = Read-Host "${GREEN}Enter JSON file name to be created (press Enter for default: exported_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($EXPORT_JSON)) { $EXPORT_JSON = "exported_data.json" }

#         if ($EXPORT_JSON -notlike "*.json") {
#             Write-Host "${RED}Error: Export file must have a .json extension.${NC}"
#             exit 1
#         }

#         $env:DATABASE_NAME = $DB_NAME
#         $env:EXPORT_JSON_PATH = $EXPORT_JSON

#         Write-Host "${GREEN}DEPipeline Stage 4: Serving Starting...${NC}"
#         Write-Host "${GREEN}DB: $DB_NAME | Export Target: $EXPORT_JSON${NC}"
#         python -m uvicorn api_server:app --reload
#     }

#     Default {
#         Write-Host "${RED}Error: Invalid stage entered.${NC}"
#     }
# }
#----------------------
# Define color variables for formatted terminal output.
$CYAN    = "$([char]27)[38;5;087m"
$ORANGE  = "$([char]27)[38;5;221m"
$YELLOW  = "$([char]27)[38;5;226m"
$MAGENTA = "$([char]27)[38;5;207m"
$GREEN   = "$([char]27)[38;5;118m"
$RED     = "$([char]27)[0;31m"
$NC      = "$([char]27)[0m"

# Read the pipeline stage from the first command-line argument.
$STAGE = $args[0]
$args = $args[1..($args.Length - 1)]

# Set the default file names for raw data, cleaned data, and the SQLite database.
$RAW_FILE    = "raw_data.json"
$CLEAN_FILE  = "cleaned_data.json"
$DB_NAME     = "faculty_data.db"
$EXPORT_JSON = "exported_data.json"
$READ_URL    = ""

# Parse command-line options passed to the script.
for ($i = 0; $i -lt $args.Length; $i++) {
    switch ($args[$i]) {
        "--url"    { $READ_URL   = $args[++$i] }
        "--input"  { $RAW_FILE   = $args[++$i] }
        "--output" { $CLEAN_FILE = $args[++$i] }
        "--db"     { $DB_NAME    = $args[++$i] }
        default {
            Write-Host "${RED}Unknown option: $($args[$i])${NC}"
            exit 1
        }
    }
}

switch ($STAGE) {

    "ingestion" {
        # Ask the user for the URL of the faculty directory to be scraped.
        if (-not $READ_URL) {
            Write-Host "${RED}Error: --url is required for ingestion.${NC}"
            exit 1
        }

        # Validate that the URL format begins with the required http protocol.
        if ($READ_URL -notlike "http*") {
            Write-Host "${RED}Error: The URL must start with http:// or https://${NC}"
            exit 1
        }

        # Verify that the target website is reachable before initiating the scraper.
        Write-Host "${CYAN}Checking website connectivity...${NC}"
        try {
            Invoke-WebRequest -Uri $READ_URL -Method Head -UseBasicParsing -ErrorAction Stop | Out-Null
            Write-Host "${GREEN}The website is reachable.${NC}"
        } catch {
            Write-Host "${RED}Error: Cannot reach $READ_URL. Aborting the ingestion process.${NC}"
            exit 1
        }

        # Ensure the specified raw data file has a valid .json extension.
        if ($RAW_FILE -notlike "*.json") {
            Write-Host "${RED}Error: The raw file must have a .json extension.${NC}"
            exit 1
        }

        Write-Host "${CYAN}DEPipeline Stage 1: The ingestion process is starting...${NC}"
        Write-Host "${CYAN}____________________________________________________________________${NC}"

        # Configure the Python path and execute the Scrapy spider in overwrite mode.
        $env:PYTHONPATH += ";."
        python -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

        # Verify that the output file was successfully created by the spider.
        if (!(Test-Path $RAW_FILE)) {
            Write-Host "${RED}Error: The output file '$RAW_FILE' was not created.${NC}"
            exit 1
        }

        # Count the number of records extracted by searching for JSON object braces.
        $recordCount = (Select-String "{" $RAW_FILE).Count

        Write-Host "${CYAN}Ingestion completed successfully.${NC}"
        Write-Host "${CYAN}Records scraped : $recordCount${NC}"
        Write-Host "${CYAN}Data saved in   : $RAW_FILE${NC}"
        Write-Host "${CYAN}____________________________________________________________________${NC}"
    }

    "transformation" {
        # Validate that the input file exists and possesses the correct .json extension.
        if ($RAW_FILE -notlike "*.json" -or !(Test-Path $RAW_FILE)) {
            Write-Host "${RED}Error: A valid .json raw file was not found.${NC}"
            exit 1
        }

        # Confirm that the output cleaning file has a .json extension.
        if ($CLEAN_FILE -notlike "*.json") {
            Write-Host "${RED}Error: The output clean file must have a .json extension.${NC}"
            exit 1
        }

        Write-Host "${YELLOW}____________________________________________________________________${NC}"
        Write-Host "${YELLOW}Stage 2: Transforming $RAW_FILE into $CLEAN_FILE...${NC}"

        # Execute the Python transformation logic.
        python transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"

        Write-Host "${YELLOW}____________________________________________________________________${NC}"
    }

    "storage" {
        # Validate that the file to be stored is a valid JSON file.
        if ($CLEAN_FILE -notlike "*.json" -or !(Test-Path $CLEAN_FILE)) {
            Write-Host "${RED}Error: A valid .json file was not found for storage.${NC}"
            exit 1
        }

        # Ensure the database filename follows the required .db extension.
        if ($DB_NAME -notlike "*.db") {
            Write-Host "${RED}Error: The database file must have a .db extension.${NC}"
            exit 1
        }

        Write-Host "${MAGENTA}____________________________________________________________________${NC}"
        Write-Host "${MAGENTA}Stage 3: Loading $CLEAN_FILE into the $DB_NAME database...${NC}"

        # Run the storage script to ingest cleaned data into SQLite.
        python storage.py --input "$CLEAN_FILE" --database "$DB_NAME"

        Write-Host "${MAGENTA}____________________________________________________________________${NC}"
    }

    "serving" {
        # Verify that the database exists and has the correct file extension.
        if ($DB_NAME -notlike "*.db" -or !(Test-Path $DB_NAME)) {
            Write-Host "${RED}Error: The database '$DB_NAME' was not found or has an invalid extension.${NC}"
            exit 1
        }

        # Validate that the export filename uses the .json extension.
        if ($EXPORT_JSON -notlike "*.json") {
            Write-Host "${RED}Error: The export file must have a .json extension.${NC}"
            exit 1
        }

        # Export environment variables and initiate the Uvicorn API server.
        $env:DATABASE_NAME = $DB_NAME
        $env:EXPORT_JSON_PATH = $EXPORT_JSON

        Write-Host "${GREEN}____________________________________________________________________${NC}"
        Write-Host "${GREEN}DEPipeline Stage 4: The serving process is starting...${NC}"
        Write-Host "${GREEN}Database: $DATABASE_NAME | Export File: $EXPORT_JSON_PATH${NC}"

        python -m uvicorn api_server:app --reload

        Write-Host "${GREEN}____________________________________________________________________${NC}"
    }

    Default {
        # Handle invalid stage entries by providing the user with valid options.
        Write-Host "${RED}Error: An invalid stage was entered.${NC}"
        Write-Host "${RED}Valid options are: ingestion | transformation | storage | serving${NC}"
    }
}
