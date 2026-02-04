#!/bin/bash

# --- Color Definitions (ANSI Escape Codes) ---
CYAN='\033[38;5;087m'
BLUE='\033[38;5;039m'
ORANGE='\033[38;5;221m'
YELLOW='\033[38;5;226m'
MAGENTA='\033[38;5;207m'
GREEN='\033[38;5;118m'
RED='\033[0;31m'
NC='\033[0m'

# --- Initialize variables ---
RAW_FILE=""
CLEAN_FILE=""
DB_NAME=""
READ_URL=""
EXPORT_JSON=""

# 1. Capture pipeline stage
STAGE="$1"
shift

# 2. Parse remaining arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --url)
            READ_URL="$2"
            shift 2
            ;;
        --input)
            RAW_FILE="$2"
            shift 2
            ;;
        --output)
            CLEAN_FILE="$2"
            shift 2
            ;;
        --db)
            DB_NAME="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

case "$STAGE" in

    ingestion)
        [[ -z "$READ_URL" ]] && {
            echo -e "${RED}Error: --url is required for ingestion.${NC}"
            exit 1
        }

        [[ ! "$READ_URL" == http* ]] && {
            echo -e "${RED}Error: The URL must start with http:// or https://${NC}"
            exit 1
        }

        echo -e "${CYAN}Checking website connectivity...${NC}"
        if curl -s -L --head "$READ_URL" | grep -E "HTTP/.* (200|301|302)" > /dev/null; then
            echo -e "${GREEN}The website is reachable.${NC}"
        else
            echo -e "${RED}Error: Cannot reach $READ_URL. Aborting ingestion.${NC}"
            exit 1
        fi

        [[ ! "$RAW_FILE" == *.json ]] && {
            echo -e "${RED}Error: The raw file must have a .json extension.${NC}"
            exit 1
        }

        echo -e "${CYAN}DEPipeline Stage 1: Ingestion starting...${NC}"
        echo -e "${CYAN}____________________________________________________________________${NC}"

        export PYTHONPATH=$PYTHONPATH:.
        python3 -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

        [[ ! -f "$RAW_FILE" ]] && {
            echo -e "${RED}Error: Output file '$RAW_FILE' was not created.${NC}"
            exit 1
        }

        recordCount=$(grep -c "{" "$RAW_FILE" || echo "0")

        echo -e "${CYAN}Ingestion completed successfully.${NC}"
        echo -e "${CYAN}Records scraped : $recordCount${NC}"
        echo -e "${CYAN}Data saved in   : $RAW_FILE${NC}"
        echo -e "${CYAN}____________________________________________________________________${NC}"
        ;;

    transformation)
        [[ ! "$RAW_FILE" == *.json || ! -f "$RAW_FILE" ]] && {
            echo -e "${RED}Error: A valid .json raw file was not found.${NC}"
            exit 1
        }

        [[ ! "$CLEAN_FILE" == *.json ]] && {
            echo -e "${RED}Error: The output clean file must have a .json extension.${NC}"
            exit 1
        }

        echo -e "${YELLOW}____________________________________________________________________${NC}"
        echo -e "${YELLOW}Stage 2: Transforming $RAW_FILE → $CLEAN_FILE${NC}"

        python3 transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"

        echo -e "${YELLOW}____________________________________________________________________${NC}"
        ;;

    storage)
        [[ ! "$CLEAN_FILE" == *.json || ! -f "$CLEAN_FILE" ]] && {
            echo -e "${RED}Error: A valid .json file was not found for storage.${NC}"
            exit 1
        }

        [[ ! "$DB_NAME" == *.db ]] && {
            echo -e "${RED}Error: The database file must have a .db extension.${NC}"
            exit 1
        }

        echo -e "${MAGENTA}____________________________________________________________________${NC}"
        echo -e "${MAGENTA}Stage 3: Loading data into $DB_NAME${NC}"

        python3 storage.py --input "$CLEAN_FILE" --database "$DB_NAME"

        echo -e "${MAGENTA}____________________________________________________________________${NC}"
        ;;

    serving)
        [[ ! "$DB_NAME" == *.db || ! -f "$DB_NAME" ]] && {
            echo -e "${RED}Error: Database '$DB_NAME' not found or invalid.${NC}"
            exit 1
        }

        export DATABASE_NAME="$DB_NAME"
        export EXPORT_JSON_PATH="$EXPORT_JSON"

        echo -e "${GREEN}____________________________________________________________________${NC}"
        echo -e "${GREEN}DEPipeline Stage 4: Serving API${NC}"
        echo -e "${GREEN}Database: $DATABASE_NAME${NC}"

        python3 -m uvicorn api_server:app --reload

        echo -e "${GREEN}____________________________________________________________________${NC}"
        ;;

    search)
        [[ -z "$CLEAN_FILE" ]] && {
            echo -e "${RED}Error: --output <file.json> is required for search.${NC}"
            exit 1
        }

        [[ ! -f "$CLEAN_FILE" ]] && {
            echo -e "${RED}Error: File '$CLEAN_FILE' does not exist.${NC}"
            exit 1
        }

        echo -e "${BLUE}____________________________________________________________________${NC}"
        echo -e "${BLUE}DEPipeline Stage 5: Semantic Search Engine${NC}"
        echo -e "${BLUE}Using Dataset: $CLEAN_FILE${NC}"

        python3 semantic_search.py

        echo -e "${BLUE}____________________________________________________________________${NC}"
        ;;

    *)
        echo -e "${RED}Error: Invalid stage entered.${NC}"
        echo -e "${RED}Valid stages: ingestion | transformation | storage | serving | search${NC}"
        ;;
esac
