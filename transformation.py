import json
import re
import os
import argparse

def run_transformation(raw_file, clean_file):
    print(f"Processing raw JSON data from {raw_file}...")

    if not os.path.exists(raw_file):
        print(f"Error: {raw_file} not found. First run the ingestion stage?")
        return

    with open(raw_file, 'r', encoding='utf-8') as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            print(f"Error: {raw_file} is empty or corrupted.")
            return

    transformed_data = []
    content_fields = ["qualification", "biography", "specialization", "publications", "teaching", "research"]

    for item in data:
        cleaned_item = {}

        name = item.get('name')
        cleaned_item['name'] = name.strip().title() if name else "Name Not Provided"

        email = item.get('email')
        if email:
            email_str = "".join(email) if isinstance(email, list) else str(email)
            cleaned_item['email'] = email_str.strip().lower()
        else:
            cleaned_item['email'] = None

        for field, value in item.items():
            if field in ['name', 'email']: continue 
            
            if isinstance(value, list):
                temp_list = [t.strip().replace('\xa0', ' ') for t in value if t.strip()]
                if temp_list:
                    cleaned_val = ", ".join(temp_list)
                else:
                    cleaned_val = f"{field.capitalize()} not provided" if field in content_fields else None
            
            else:
                if value:
                    cleaned_val = re.sub(r'\s+', ' ', str(value).strip().replace('\xa0', ' '))
                    
                    if field == 'phone':
                        digits = re.sub(r'\D', '', cleaned_val)
                        cleaned_val = digits if 10 <= len(digits) <= 11 else None
                else:
                    cleaned_val = f"{field.capitalize()} not provided" if field in content_fields else None
            
            cleaned_item[field] = cleaned_val

        transformed_data.append(cleaned_item)

    with open(clean_file, 'w', encoding='utf-8') as f:
        json.dump(transformed_data, f, indent=4)

    print(f"Transformation Complete: {len(transformed_data)} records saved to {clean_file}.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="raw_data.json")
    parser.add_argument("--output", default="cleaned_data.json")
    args = parser.parse_args()
    
    run_transformation(args.input, args.output)