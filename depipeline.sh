# # #!/bin/bash

# # # Define color variables for formatted terminal output.
# # CYAN='\033[38;5;087m'
# # ORANGE='\033[38;5;221m'
# # YELLOW='\033[38;5;226m'
# # MAGENTA='\033[38;5;207m'
# # GREEN='\033[38;5;118m'
# # RED='\033[0;31m'
# # NC='\033[0m'

# # # Prompt the user to enter the specific pipeline stage they wish to execute.
# # echo -ne "${ORANGE}Enter pipeline stage (ingestion / transformation / storage / serving): ${NC}"
# # read STAGE

# # # Set the default file names for raw data, cleaned data, and the SQLite database.
# # RAW_FILE="raw_data.json"
# # CLEAN_FILE="cleaned_data.json"
# # DB_NAME="faculty_data.db"
# # EXPORT_JSON="exported_data.json"

# # case "$STAGE" in
# #     "ingestion")
# #         # Ask the user for the URL of the faculty directory to be scraped.
# #         echo -ne "${CYAN}Enter READ URL for ingestion: ${NC}"
# #         read READ_URL

# #         # Validate that the URL format begins with the required http protocol.
# #         if [[ ! "$READ_URL" == http* ]]; then
# #             echo -e "${RED}Error: The URL must start with http:// or https://${NC}"
# #             exit 1
# #         fi

# #         # Verify that the target website is reachable before initiating the scraper.
# #         echo -e "${CYAN}Checking website connectivity...${NC}"
# #         if curl -s -L --head "$READ_URL" | grep -E "HTTP/.* (200|301|302)" > /dev/null; then
#             echo -e "${GREEN}The website is reachable.${NC}"
#           else
#             echo -e "${RED}Error: Cannot reach $READ_URL. Aborting the ingestion process.${NC}"
#             exit 1
#           fi


# #         # Prompt the user for a filename to store the raw scraped data.
# #         echo -ne "${CYAN}Enter RAW file name (press Enter for default: raw_data.json): ${NC}"
# #         read USER_RAW
# #         if [ -n "$USER_RAW" ]; then RAW_FILE=$USER_RAW; fi

# #         # Ensure the specified raw data file has a valid .json extension.
# #         if [[ ! "$RAW_FILE" == *.json ]]; then
# #             echo -e "${RED}Error: The raw file must have a .json extension.${NC}"
# #             exit 1
# #         fi

# #         echo -e "${CYAN}DEPipeline Stage 1: The ingestion process is starting...${NC}"

# #         # Configure the Python path and execute the Scrapy spider in overwrite mode.
# #         export PYTHONPATH=$PYTHONPATH:.
# #         python3 -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

# #         # Verify that the output file was successfully created by the spider.
# #         if [ ! -f "$RAW_FILE" ]; then
# #             echo -e "${RED}Error: The output file '$RAW_FILE' was not created.${NC}"
# #             exit 1
# #         fi

# #         # Count the number of records extracted by searching for JSON object braces.
# #         recordCount=$(grep -c "{" "$RAW_FILE" || echo "0")

# #         echo -e "${CYAN}Ingestion completed successfully.${NC}"
# #         echo -e "${CYAN}Records scraped : $recordCount${NC}"
# #         echo -e "${CYAN}Data saved in   : $RAW_FILE${NC}"
# #         echo -e "${CYAN}____________________________________________________________________${NC}"
# #         ;;

# #     "transformation")
# #         # Ask the user to identify the raw data file that needs cleaning.
# #         echo -ne "${YELLOW}Enter RAW file name (press Enter for default: raw_data.json): ${NC}"
# #         read USER_RAW
# #         if [ -n "$USER_RAW" ]; then RAW_FILE=$USER_RAW; fi

# #         # Validate that the input file exists and possesses the correct .json extension.
# #         if [[ ! "$RAW_FILE" == *.json ]] || [ ! -f "$RAW_FILE" ]; then
# #             echo -e "${RED}Error: A valid .json raw file was not found.${NC}"
# #             exit 1
# #         fi

# #         # Prompt the user for a filename to store the transformed and cleaned data.
# #         echo -ne "${YELLOW}Enter CLEAN file name (press Enter for default: cleaned_data.json): ${NC}"
# #         read USER_CLEAN
# #         if [ -n "$USER_CLEAN" ]; then CLEAN_FILE=$USER_CLEAN; fi

# #         # Confirm that the output cleaning file has a .json extension.
# #         if [[ ! "$CLEAN_FILE" == *.json ]]; then
# #             echo -e "${RED}Error: The output clean file must have a .json extension.${NC}"
# #             exit 1
# #         fi

# #         echo -e "${YELLOW}____________________________________________________________________${NC}"
# #         echo -e "${YELLOW}Stage 2: Transforming $RAW_FILE into $CLEAN_FILE...${NC}"

# #         # Execute the Python transformation logic.
# #         python3 transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"
# #         echo -e "${YELLOW}____________________________________________________________________${NC}"
# #         ;;

# #     "storage")
# #         # Prompt the user for the name of the cleaned data file to be stored.
# #         echo -ne "${MAGENTA}Enter CLEANED file name (press Enter for default: cleaned_data.json): ${NC}"
# #         read USER_CLEAN
# #         if [ -n "$USER_CLEAN" ]; then CLEAN_FILE=$USER_CLEAN; fi

# #         # Validate that the file to be stored is a valid JSON file.
# #         if [[ ! "$CLEAN_FILE" == *.json ]] || [ ! -f "$CLEAN_FILE" ]; then
# #             echo -e "${RED}Error: A valid .json file was not found for storage.${NC}"
# #             exit 1
# #         fi

# #         # Ask the user for the name of the SQLite database file to be used.
# #         echo -ne "${MAGENTA}Enter Database name (press Enter for default: faculty_data.db): ${NC}"
# #         read USER_DB
# #         if [ -n "$USER_DB" ]; then DB_NAME=$USER_DB; fi

# #         # Ensure the database filename follows the required .db extension.
# #         if [[ ! "$DB_NAME" == *.db ]]; then
# #             echo -e "${RED}Error: The database file must have a .db extension.${NC}"
# #             exit 1
# #         fi

# #         echo -e "${MAGENTA}____________________________________________________________________${NC}"
# #         echo -e "${MAGENTA}Stage 3: Loading $CLEAN_FILE into the $DB_NAME database...${NC}"

# #         # Run the storage script to ingest cleaned data into SQLite.
# #         python3 storage.py --input "$CLEAN_FILE" --database "$DB_NAME"
# #         echo -e "${MAGENTA}____________________________________________________________________${NC}"
# #         ;;

# #     "serving")
# #         # Ask the user for the database file to be used by the API server.
# #         echo -ne "${GREEN}Enter Database name (press Enter for default: faculty_data.db): ${NC}"
# #         read USER_DB
# #         if [ -n "$USER_DB" ]; then DB_NAME=$USER_DB; fi

# #         # Verify that the database exists and has the correct file extension.
# #         if [[ ! "$DB_NAME" == *.db ]] || [ ! -f "$DB_NAME" ]; then
# #             echo -e "${RED}Error: The database '$DB_NAME' was not found or has an invalid extension.${NC}"
# #             exit 1
# #         fi

# #         # Prompt the user for a JSON filename to store exported data during serving.
# #         echo -ne "${GREEN}Enter JSON file name to be created (press Enter for default: exported_data.json): ${NC}"
# #         read USER_EXPORT
# #         if [ -n "$USER_EXPORT" ]; then EXPORT_JSON=$USER_EXPORT; fi

# #         # Validate that the export filename uses the .json extension.
# #         if [[ ! "$EXPORT_JSON" == *.json ]]; then
# #             echo -e "${RED}Error: The export file must have a .json extension.${NC}"
# #             exit 1
# #         fi

# #         # Export environment variables and initiate the Uvicorn API server.
# #         export DATABASE_NAME=$DB_NAME
# #         export EXPORT_JSON_PATH=$EXPORT_JSON
        
# #         echo -e "${GREEN}DEPipeline Stage 4: The serving process is starting...${NC}"
# #         echo -e "${GREEN}Database: $DATABASE_NAME | Export File: $EXPORT_JSON_PATH${NC}"
# #         python3 -m uvicorn api_server:app --reload
# #         echo -e "${GREEN}____________________________________________________________________${NC}"
# #         ;;

# #     *)
# #         # Handle invalid stage entries by providing the user with valid options.
# #         echo -e "${RED}Error: An invalid stage was entered.${NC}"
# #         echo -e "${RED}Valid options are: ingestion | transformation | storage | serving${NC}"
# #         ;;
# # esac
#--------------
#!/bin/bash

# Define color variables for formatted terminal output.
CYAN='\033[38;5;087m'
ORANGE='\033[38;5;221m'
YELLOW='\033[38;5;226m'
MAGENTA='\033[38;5;207m'
GREEN='\033[38;5;118m'
RED='\033[0;31m'
NC='\033[0m'

# Read the pipeline stage from the first command-line argument.
STAGE="$1"
shift

# Set the default file names for raw data, cleaned data, and the SQLite database.
RAW_FILE="raw_data.json"
CLEAN_FILE="cleaned_data.json"
DB_NAME="faculty_data.db"
EXPORT_JSON="exported_data.json"
READ_URL=""

# Parse command-line options passed to the script.
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
        # Ask the user for the URL of the faculty directory to be scraped.
        if [[ -z "$READ_URL" ]]; then
            echo -e "${RED}Error: --url is required for ingestion.${NC}"
            exit 1
        fi

        # Validate that the URL format begins with the required http protocol.
        if [[ ! "$READ_URL" == http* ]]; then
            echo -e "${RED}Error: The URL must start with http:// or https://${NC}"
            exit 1
        fi

        # Verify that the target website is reachable before initiating the scraper.
        echo -e "${CYAN}Checking website connectivity...${NC}"
        if curl -s -L --head "$READ_URL" | grep -E "HTTP/.* (200|301|302)" > /dev/null
        then
                echo -e "${GREEN}The website is reachable.${NC}"
        else
                echo -e "${RED}Error: Cannot reach $READ_URL. Aborting the ingestion process.${NC}"
                exit 1
        fi


        # Ensure the specified raw data file has a valid .json extension.
        if [[ ! "$RAW_FILE" == *.json ]]; then
            echo -e "${RED}Error: The raw file must have a .json extension.${NC}"
            exit 1
        fi

        echo -e "${CYAN}DEPipeline Stage 1: The ingestion process is starting...${NC}"
        echo -e "${CYAN}____________________________________________________________________${NC}"

        # Configure the Python path and execute the Scrapy spider in overwrite mode.
        export PYTHONPATH=$PYTHONPATH:.
        python3 -m scrapy crawl faculty_spider -a start_url="$READ_URL" -O "$RAW_FILE"

        # Verify that the output file was successfully created by the spider.
        if [ ! -f "$RAW_FILE" ]; then
            echo -e "${RED}Error: The output file '$RAW_FILE' was not created.${NC}"
            exit 1
        fi

        # Count the number of records extracted by searching for JSON object braces.
        recordCount=$(grep -c "{" "$RAW_FILE" || echo "0")

        echo -e "${CYAN}Ingestion completed successfully.${NC}"
        echo -e "${CYAN}Records scraped : $recordCount${NC}"
        echo -e "${CYAN}Data saved in   : $RAW_FILE${NC}"
        echo -e "${CYAN}____________________________________________________________________${NC}"
        ;;

    transformation)
        # Validate that the input file exists and possesses the correct .json extension.
        if [[ ! "$RAW_FILE" == *.json ]] || [ ! -f "$RAW_FILE" ]; then
            echo -e "${RED}Error: A valid .json raw file was not found.${NC}"
            exit 1
        fi

        # Confirm that the output cleaning file has a .json extension.
        if [[ ! "$CLEAN_FILE" == *.json ]]; then
            echo -e "${RED}Error: The output clean file must have a .json extension.${NC}"
            exit 1
        fi

        echo -e "${YELLOW}____________________________________________________________________${NC}"
        echo -e "${YELLOW}Stage 2: Transforming $RAW_FILE into $CLEAN_FILE...${NC}"

        # Execute the Python transformation logic.
        python3 transformation.py --input "$RAW_FILE" --output "$CLEAN_FILE"

        echo -e "${YELLOW}____________________________________________________________________${NC}"
        ;;

    storage)
        # Validate that the file to be stored is a valid JSON file.
        if [[ ! "$CLEAN_FILE" == *.json ]] || [ ! -f "$CLEAN_FILE" ]; then
            echo -e "${RED}Error: A valid .json file was not found for storage.${NC}"
            exit 1
        fi

        # Ensure the database filename follows the required .db extension.
        if [[ ! "$DB_NAME" == *.db ]]; then
            echo -e "${RED}Error: The database file must have a .db extension.${NC}"
            exit 1
        fi

        echo -e "${MAGENTA}____________________________________________________________________${NC}"
        echo -e "${MAGENTA}Stage 3: Loading $CLEAN_FILE into the $DB_NAME database...${NC}"

        # Run the storage script to ingest cleaned data into SQLite.
        python3 storage.py --input "$CLEAN_FILE" --database "$DB_NAME"

        echo -e "${MAGENTA}____________________________________________________________________${NC}"
        ;;

    serving)
        # Verify that the database exists and has the correct file extension.
        if [[ ! "$DB_NAME" == *.db ]] || [ ! -f "$DB_NAME" ]; then
            echo -e "${RED}Error: The database '$DB_NAME' was not found or has an invalid extension.${NC}"
            exit 1
        fi

        # Validate that the export filename uses the .json extension.
        if [[ ! "$EXPORT_JSON" == *.json ]]; then
            echo -e "${RED}Error: The export file must have a .json extension.${NC}"
            exit 1
        fi

        # Export environment variables and initiate the Uvicorn API server.
        export DATABASE_NAME=$DB_NAME
        export EXPORT_JSON_PATH=$EXPORT_JSON

        echo -e "${GREEN}____________________________________________________________________${NC}"
        echo -e "${GREEN}DEPipeline Stage 4: The serving process is starting...${NC}"
        echo -e "${GREEN}Database: $DATABASE_NAME | Export File: $EXPORT_JSON_PATH${NC}"

        python3 -m uvicorn api_server:app --reload

        echo -e "${GREEN}____________________________________________________________________${NC}"
        ;;

    *)
        # Handle invalid stage entries by providing the user with valid options.
        echo -e "${RED}Error: An invalid stage was entered.${NC}"
        echo -e "${RED}Valid options are: ingestion | transformation | storage | serving${NC}"
        ;;
esac
