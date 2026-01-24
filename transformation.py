import json
import re
import os
import argparse

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

    transformed_data = []
    content_fields = ["qualification", "biography", "specialization", "publications", "teaching", "research"]

    for item in data:
        # Collapse all whitespace and title-case the name
        cleaned = {k: " ".join(str(v).split()) if v else None for k, v in item.items()}
        
        if cleaned.get('name'): cleaned['name'] = cleaned['name'].title()
        if cleaned.get('email'): cleaned['email'] = cleaned['email'].replace(" ", "").lower()
        if cleaned.get('phone'): cleaned['phone'] = re.sub(r'\D', '', cleaned['phone'])
        if cleaned.get('faculty_type'): cleaned['faculty_type'] = cleaned['faculty_type'].replace("-", " ").title()

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
