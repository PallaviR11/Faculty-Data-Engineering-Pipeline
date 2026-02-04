# --- Color Definitions (ANSI Escape Codes) ---
$CYAN    = "$([char]27)[38;5;087m"
$BLUE    = "$([char]27)[38;5;039m"
$ORANGE  = "$([char]27)[38;5;221m"
$YELLOW  = "$([char]27)[38;5;226m"
$MAGENTA = "$([char]27)[38;5;207m"
$GREEN   = "$([char]27)[38;5;118m"
$RED     = "$([char]27)[0;31m"
$NC      = "$([char]27)[0m"

# --- Initialize variables as empty strings to prevent 'null' errors ---
$RAW_FILE    = ""
$CLEAN_FILE  = ""
$DB_NAME     = ""
$READ_URL    = ""
$EXPORT_JSON = "" 

# 1. Capture the stage correctly
$STAGE = $args[0]

# 2. Extract only the remaining arguments (options) into a new variable
$PARAMS = $args | Select-Object -Skip 1

# 3. Parse the options using the new $PARAMS variable
for ($i = 0; $i -lt $PARAMS.Length; $i++) {
    switch ($PARAMS[$i]) {
        "--url"    { $READ_URL   = $PARAMS[++$i] }
        "--input"  { $RAW_FILE   = $PARAMS[++$i] }
        "--output" { $CLEAN_FILE = $PARAMS[++$i] }
        "--db"     { $DB_NAME    = $PARAMS[++$i] }
        default {
            Write-Host "${RED}Unknown option: $($PARAMS[$i])${NC}"
            exit 1
        }
    }
}

switch ($STAGE) {

    "ingestion" {
        if (-not $READ_URL) {
            Write-Host "${RED}Error: --url is required for ingestion.${NC}"
            exit 1
        }

        if ($READ_URL -notlike "http*") {
            Write-Host "${RED}Error: The URL must start with http:// or https://${NC}"
            exit 1
        }

        Write-Host "${CYAN}Checking website connectivity...${NC}"
        try {
            Invoke-WebRequest -Uri $READ_URL -Method Head -UseBasicParsing -ErrorAction Stop | Out-Null
            Write-Host "${GREEN}The website is reachable.${NC}"
        } catch {
            Write-Host "${RED}Error: Cannot reach $READ_URL. Aborting the ingestion process.${NC}"
            exit 1
        }

        if ($RAW_FILE -notlike "*.json") {
            Write-Host "${RED}Error: The raw file must have a .json extension.${NC}"
            exit 1
        }

        Write-Host "${CYAN}DEPipeline Stage 1: The ingestion process is starting...${NC}"
        Write-Host "${CYAN}____________________________________________________________________${NC}"

        $env:PYTHONPATH += ";."
        python -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

        if (!(Test-Path $RAW_FILE)) {
            Write-Host "${RED}Error: The output file '$RAW_FILE' was not created.${NC}"
            exit 1
        }

        $recordCount = (Select-String "{" $RAW_FILE).Count

        Write-Host "${CYAN}Ingestion completed successfully.${NC}"
        Write-Host "${CYAN}Records scraped : $recordCount${NC}"
        Write-Host "${CYAN}Data saved in   : $RAW_FILE${NC}"
        Write-Host "${CYAN}____________________________________________________________________${NC}"
    }

    "transformation" {
        if ($RAW_FILE -notlike "*.json" -or !(Test-Path $RAW_FILE)) {
            Write-Host "${RED}Error: A valid .json raw file was not found.${NC}"
            exit 1
        }

        if ($CLEAN_FILE -notlike "*.json") {
            Write-Host "${RED}Error: The output clean file must have a .json extension.${NC}"
            exit 1
        }

        Write-Host "${YELLOW}____________________________________________________________________${NC}"
        Write-Host "${YELLOW}Stage 2: Transforming $RAW_FILE into $CLEAN_FILE...${NC}"

        python transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"

        Write-Host "${YELLOW}____________________________________________________________________${NC}"
    }

    "storage" {
        if ($CLEAN_FILE -notlike "*.json" -or !(Test-Path $CLEAN_FILE)) {
            Write-Host "${RED}Error: A valid .json file was not found for storage.${NC}"
            exit 1
        }

        if ($DB_NAME -notlike "*.db") {
            Write-Host "${RED}Error: The database file must have a .db extension.${NC}"
            exit 1
        }

        Write-Host "${MAGENTA}____________________________________________________________________${NC}"
        Write-Host "${MAGENTA}Stage 3: Loading $CLEAN_FILE into the $DB_NAME database...${NC}"

        python storage.py --input "$CLEAN_FILE" --database "$DB_NAME"

        Write-Host "${MAGENTA}____________________________________________________________________${NC}"
    }

    "serving" {
        if ($DB_NAME -notlike "*.db" -or !(Test-Path $DB_NAME)) {
            Write-Host "${RED}Error: The database '$DB_NAME' was not found or has an invalid extension.${NC}"
            exit 1
        }

        $env:DATABASE_NAME = $DB_NAME
        $env:EXPORT_JSON_PATH = $EXPORT_JSON

        Write-Host "${GREEN}____________________________________________________________________${NC}"
        Write-Host "${GREEN}DEPipeline Stage 4: The serving process is starting...${NC}"
        Write-Host "${GREEN}Database: $env:DATABASE_NAME | Export File: $env:EXPORT_JSON_PATH${NC}"

        python -m uvicorn api_server:app --reload

        Write-Host "${GREEN}____________________________________________________________________${NC}"
    }

    "search" {
        # First, check if the variable is empty
        if (-not $CLEAN_FILE) {
            Write-Host "${RED}Error: You must provide a file to search using --output <filename.json>${NC}"
            exit 1
        }

        # Now it is safe to check if the file actually exists
        if (!(Test-Path $CLEAN_FILE)) {
            Write-Host "${RED}Error: The file '$CLEAN_FILE' does not exist.${NC}"
            exit 1
        }

        Write-Host "${BLUE}____________________________________________________________________${NC}"
        Write-Host "${BLUE}DEPipeline Stage 5: Launching Semantic Search Engine...${NC}"
        Write-Host "${BLUE}Using Dataset: $CLEAN_FILE${NC}"

        python semantic_search.py

        Write-Host "${BLUE}____________________________________________________________________${NC}"
    }

    Default {
        Write-Host "${RED}Error: An invalid stage was entered.${NC}"
        Write-Host "${RED}Valid options are: ingestion | transformation | storage | serving | search${NC}"
    }
}
