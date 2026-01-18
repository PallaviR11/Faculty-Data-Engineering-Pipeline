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
# $RAW_FILE   = "raw_data.json"
# $CLEAN_FILE = "cleaned_data.json"
# $DB_NAME    = "faculty_data.db"

# switch ($STAGE) {

#     "ingestion" {
#         $READ_URL = Read-Host "${CYAN}Enter READ URL for ingestion${NC}"

#         # URL FORMAT AND CONNECTIVITY CHECK
#         if ($READ_URL -notlike "http*") {
#             Write-Host "${RED}Error: URL must start with 'http://' or 'https://'.${NC}"
#             exit 1
#         }

#         Write-Host "${CYAN}Checking website connectivity...${NC}"
#         try {
#             $response = Invoke-WebRequest -Uri $READ_URL -Method Head -ErrorAction Stop
#             Write-Host "${GREEN}Website reachable (Status: $($response.StatusCode)).${NC}"
#         } catch {
#             Write-Host "${RED}Error: Cannot reach $READ_URL. Check the URL or your network.${NC}"
#             exit 1
#         }

#         $RAW_FILE = Read-Host "${CYAN}Enter RAW file name (press Enter for default: raw_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($RAW_FILE)) { $RAW_FILE = "raw_data.json" }

#         # EXTENSION CHECK
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

#         Write-Host "${CYAN}Ingestion completed successfully.${NC}"
#         Write-Host "${CYAN}Records scraped : $recordCount${NC}"
#         Write-Host "${CYAN}Data saved in   : $RAW_FILE${NC}"
#         Write-Host "${CYAN}____________________________________________________________________${NC}"
#     }

#     "transformation" {
#         $RAW_FILE = Read-Host "${YELLOW}Enter RAW file name (press Enter for default: raw_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($RAW_FILE)) { $RAW_FILE = "raw_data.json" }

#         # EXTENSION CHECK
#         if ($RAW_FILE -notlike "*.json") {
#             Write-Host "${RED}Error: Input RAW file must be a .json file.${NC}"
#             exit 1
#         }

#         if (!(Test-Path $RAW_FILE)) {
#             Write-Host "${RED}Error: Input file '$RAW_FILE' not found.${NC}"
#             exit 1
#         }

#         $CLEAN_FILE = Read-Host "${YELLOW}Enter CLEAN file name (press Enter for default: cleaned_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($CLEAN_FILE)) { $CLEAN_FILE = "cleaned_data.json" }

#         # EXTENSION CHECK
#         if ($CLEAN_FILE -notlike "*.json") {
#             Write-Host "${RED}Error: Output CLEAN file must have a .json extension.${NC}"
#             exit 1
#         }

#         Write-Host "${YELLOW}____________________________________________________________________${NC}"

#         Write-Host "${YELLOW}Stage 2: Transforming $RAW_FILE -> $CLEAN_FILE...${NC}"
#         python transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"
#         Write-Host "${YELLOW}____________________________________________________________________${NC}"
#     }

#     "storage" {
#         $CLEAN_FILE = Read-Host "${MAGENTA}Enter CLEAN file name (press Enter for default: cleaned_data.json)${NC}"
#         if ([string]::IsNullOrWhiteSpace($CLEAN_FILE)) { $CLEAN_FILE = "cleaned_data.json" }

#         # JSON EXTENSION CHECK
#         if ($CLEAN_FILE -notlike "*.json") {
#             Write-Host "${RED}Error: Input file must be a .json file.${NC}"
#             exit 1
#         }

#         $DB_NAME = Read-Host "${MAGENTA}Enter Database name (press Enter for default: faculty_data.db)${NC}"
#         if ([string]::IsNullOrWhiteSpace($DB_NAME)) { $DB_NAME = "faculty_data.db" }

#         # DB EXTENSION CHECK
#         if ($DB_NAME -notlike "*.db") {
#             Write-Host "${RED}Error: Database file must have a .db extension.${NC}"
#             exit 1
#         }

#         Write-Host "${MAGENTA}____________________________________________________________________${NC}"

#         if (!(Test-Path $CLEAN_FILE)) {
#             Write-Host "${RED}Error: Cleaned file '$CLEAN_FILE' not found.${NC}"
#             exit 1
#         }

#         Write-Host "${MAGENTA}Stage 3: Loading $CLEAN_FILE into $DB_NAME...${NC}"
#         python storage.py --input "$CLEAN_FILE" --database "$DB_NAME"
#         Write-Host "${MAGENTA}____________________________________________________________________${NC}"
#     }

#     "serving" {
#         $DB_NAME = Read-Host "${GREEN}Enter Database name (press Enter for default: faculty_data.db)${NC}"
#         if ([string]::IsNullOrWhiteSpace($DB_NAME)) { $DB_NAME = "faculty_data.db" }

#         # DB EXTENSION CHECK
#         if ($DB_NAME -notlike "*.db") {
#             Write-Host "${RED}Error: Serving requires a .db database file.${NC}"
#             exit 1
#         }

#         Write-Host "${GREEN}____________________________________________________________________${NC}"

#         if (!(Test-Path $DB_NAME)) {
#             Write-Host "${RED}Error: Database '$DB_NAME' not found.${NC}"
#             exit 1
#         }

#         $env:DATABASE_NAME = $DB_NAME
#         Write-Host "${GREEN}DEPipeline Stage 4: Serving Starting...${NC}"
#         python -m uvicorn api_server:app --reload
#         Write-Host "${GREEN}____________________________________________________________________${NC}"
#     }

#     Default {
#         Write-Host "${RED}Error: Invalid stage entered.${NC}"
#         Write-Host "${RED}Valid stages: ingestion | transformation | storage | serving${NC}"
#     }
# }
# COLORS
$CYAN    = "$([char]27)[0;36m"
$ORANGE  = "$([char]27)[38;5;178m"
$YELLOW  = "$([char]27)[38;5;226m"
$MAGENTA = "$([char]27)[38;5;207m"
$GREEN   = "$([char]27)[38;5;118m"
$RED     = "$([char]27)[0;31m"
$NC      = "$([char]27)[0m"

# STAGE INPUT
$STAGE = Read-Host "${ORANGE}Enter pipeline stage (ingestion / transformation / storage / serving)${NC}"

# DEFAULT FILE NAMES
$RAW_FILE    = "raw_data.json"
$CLEAN_FILE  = "cleaned_data.json"
$DB_NAME     = "faculty_data.db"
$EXPORT_JSON = "exported_data.json"

switch ($STAGE) {

    "ingestion" {
        $READ_URL = Read-Host "${CYAN}Enter READ URL for ingestion${NC}"
        if ($READ_URL -notlike "http*") {
            Write-Host "${RED}Error: URL must start with 'http://' or 'https://'.${NC}"
            exit 1
        }

        Write-Host "${CYAN}Checking website connectivity...${NC}"
        try {
            $response = Invoke-WebRequest -Uri $READ_URL -Method Head -ErrorAction Stop
            Write-Host "${GREEN}Website reachable (Status: $($response.StatusCode)).${NC}"
        } catch {
            Write-Host "${RED}Error: Cannot reach $READ_URL.${NC}"
            exit 1
        }

        $RAW_FILE = Read-Host "${CYAN}Enter RAW file name (press Enter for default: raw_data.json)${NC}"
        if ([string]::IsNullOrWhiteSpace($RAW_FILE)) { $RAW_FILE = "raw_data.json" }

        if ($RAW_FILE -notlike "*.json") {
            Write-Host "${RED}Error: RAW file must have a .json extension.${NC}"
            exit 1
        }

        Write-Host "${CYAN}DEPipeline Stage 1: Ingestion Starting...${NC}"
        $env:PYTHONPATH += ";."
        python -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

        if (!(Test-Path $RAW_FILE)) {
            Write-Host "${RED}Error: Output file '$RAW_FILE' not created.${NC}"
            exit 1
        }

        $recordCount = (Get-Content $RAW_FILE | Where-Object { $_.Trim() -ne "" }).Count
        Write-Host "${CYAN}Ingestion completed. Records: $recordCount | Saved: $RAW_FILE${NC}"
    }

    "transformation" {
        $RAW_FILE = Read-Host "${YELLOW}Enter RAW file name (press Enter for default: raw_data.json)${NC}"
        if ([string]::IsNullOrWhiteSpace($RAW_FILE)) { $RAW_FILE = "raw_data.json" }

        if ($RAW_FILE -notlike "*.json" -or !(Test-Path $RAW_FILE)) {
            Write-Host "${RED}Error: Valid .json RAW file not found.${NC}"
            exit 1
        }

        $CLEAN_FILE = Read-Host "${YELLOW}Enter CLEAN file name (press Enter for default: cleaned_data.json)${NC}"
        if ([string]::IsNullOrWhiteSpace($CLEAN_FILE)) { $CLEAN_FILE = "cleaned_data.json" }

        if ($CLEAN_FILE -notlike "*.json") {
            Write-Host "${RED}Error: Output CLEAN file must have a .json extension.${NC}"
            exit 1
        }

        Write-Host "${YELLOW}Stage 2: Transforming $RAW_FILE -> $CLEAN_FILE...${NC}"
        python transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"
    }

    "storage" {
        $CLEAN_FILE = Read-Host "${MAGENTA}Enter CLEANED file name (press Enter for default: cleaned_data.json)${NC}"
        if ([string]::IsNullOrWhiteSpace($CLEAN_FILE)) { $CLEAN_FILE = "cleaned_data.json" }

        if ($CLEAN_FILE -notlike "*.json" -or !(Test-Path $CLEAN_FILE)) {
            Write-Host "${RED}Error: Valid .json file not found.${NC}"
            exit 1
        }

        $DB_NAME = Read-Host "${MAGENTA}Enter Database name (press Enter for default: faculty_data.db)${NC}"
        if ([string]::IsNullOrWhiteSpace($DB_NAME)) { $DB_NAME = "faculty_data.db" }

        if ($DB_NAME -notlike "*.db") {
            Write-Host "${RED}Error: Database file must have a .db extension.${NC}"
            exit 1
        }

        Write-Host "${MAGENTA}Stage 3: Loading $CLEAN_FILE into $DB_NAME...${NC}"
        python storage.py --input "$CLEAN_FILE" --database "$DB_NAME"
    }

    "serving" {
        $DB_NAME = Read-Host "${GREEN}Enter Database name (press Enter for default: faculty_data.db)${NC}"
        if ([string]::IsNullOrWhiteSpace($DB_NAME)) { $DB_NAME = "faculty_data.db" }

        if ($DB_NAME -notlike "*.db" -or !(Test-Path $DB_NAME)) {
            Write-Host "${RED}Error: Database '$DB_NAME' not found or invalid extension.${NC}"
            exit 1
        }

        # NEW: Input for JSON file to be created during serving
        $EXPORT_JSON = Read-Host "${GREEN}Enter JSON file name to be created (press Enter for default: exported_data.json)${NC}"
        if ([string]::IsNullOrWhiteSpace($EXPORT_JSON)) { $EXPORT_JSON = "exported_data.json" }

        if ($EXPORT_JSON -notlike "*.json") {
            Write-Host "${RED}Error: Export file must have a .json extension.${NC}"
            exit 1
        }

        $env:DATABASE_NAME = $DB_NAME
        $env:EXPORT_JSON_PATH = $EXPORT_JSON

        Write-Host "${GREEN}DEPipeline Stage 4: Serving Starting...${NC}"
        Write-Host "${GREEN}DB: $DB_NAME | Export Target: $EXPORT_JSON${NC}"
        python -m uvicorn api_server:app --reload
    }

    Default {
        Write-Host "${RED}Error: Invalid stage entered.${NC}"
    }
}