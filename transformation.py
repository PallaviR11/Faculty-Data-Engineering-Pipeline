import json, re, os, argparse

def run_transformation(raw_file, clean_file):
    print(f"Processing raw JSON data from {raw_file}...")

    if not os.path.exists(raw_file):
        print(f"Error: {raw_file} not found. First run the ingestion stage!")
        return

    with open(raw_file, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error: {raw_file} is empty or corrupted.")
            return
    
    # Fields that should never be null in the UI
    content_fields = [
        "qualification", "specialization", "teaching", 
        "research", "publications", "biography"
    ]

    transformed_data = []
    for item in data:
        cleaned = {}
        for k, v in item.items():
            # 1. Flatten lists into strings
            if isinstance(v, list):
                val_str = ", ".join([str(i).strip() for i in v if i])
            else:
                val_str = str(v) if v else ""
                
            # Remove escaped quotes, fix double commas, and normalize spacing to clean HTML noise
            val_str = val_str.replace('\\"', '"').replace(',,', ',')
            val_str = val_str.replace(' , ', ', ').replace(' ,', ',')

            # 2. Advanced cleaning: Collapse whitespace and remove stray leading/trailing commas
            val_str = " ".join(val_str.split()).strip().strip(',').strip() # Added extra .strip() at the end

            # 3. Handle missing values professionally
            if not val_str and k in content_fields:
                cleaned[k] = f"{k.replace('_', ' ').capitalize()} not provided"
            elif not val_str:
                cleaned[k] = None 
            else:
                cleaned[k] = val_str

                # 4. Standardize Specific Fields
                if cleaned.get('name'): 
                    cleaned['name'] = cleaned['name'].title()
                if cleaned.get('faculty_type'): 
                    cleaned['faculty_type'] = cleaned['faculty_type'].replace("-", " ").title()

        transformed_data.append(cleaned)

    with open(clean_file, 'w', encoding='utf-8') as f:
        json.dump(transformed_data, f, indent=4)
    print(f"Transformation Complete: {len(transformed_data)} records saved to {clean_file}.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="raw_data.json")
    parser.add_argument("--output", default="cleaned_data.json")
    args = parser.parse_args()
    
    run_transformation(args.input, args.output)
