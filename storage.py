import sqlite3
import json
import os
import argparse

def run_storage(input_file, db_path):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    print(f"Initializing Schema in {db_path}...")

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS Faculty (
            id INTEGER PRIMARY KEY AUTOINCREMENT,

            -- Identity
            faculty_type TEXT,
            name TEXT,

            -- Contact information
            email TEXT,
            phone TEXT,
            professional_link TEXT,
            address TEXT,

            -- Academic profile
            qualification TEXT,
            specialization TEXT,
            teaching TEXT,
            research TEXT,

            -- Long free-text
            publications TEXT,
            biography TEXT,

            UNIQUE(name, phone)
        )
    """)

    if os.path.exists(input_file):
        with open(input_file, 'r') as f:
            data = json.load(f)
            
        for item in data:
            cursor.execute("""
                INSERT INTO Faculty (
                    faculty_type, name, email, phone, professional_link, 
                    address, qualification, specialization, teaching,
                    research, publications, biography
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT(name, phone) DO UPDATE SET
                faculty_type = excluded.faculty_type,
                email = excluded.email,
                professional_link = excluded.professional_link,
                address = excluded.address,
                qualification = excluded.qualification,
                specialization = excluded.specialization,
                teaching = excluded.teaching,
                research = excluded.research,
                publications = excluded.publications,
                biography = excluded.biography
        """, (
            item.get('faculty_type'),
            item.get('name'),
            item.get('email'),
            item.get('phone'),
            item.get('professional_link'),
            item.get('address'),
            item.get('qualification'),
            item.get('specialization'),
            item.get('teaching'),
            item.get('research'),
            item.get('publications'),
            item.get('biography')
        ))
        
        conn.commit()
        print(f"Storage Complete: Data from {input_file} persisted in {db_path}.")
    else:
        print(f"No cleaned data found at {input_file} to store.")

    conn.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="cleaned_data.json")
    parser.add_argument("--database", default="faculty_data.db")
    args = parser.parse_args()
    
    run_storage(args.input, args.database)
