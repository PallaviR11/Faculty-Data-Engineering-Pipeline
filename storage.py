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
            image_url TEXT,
            name TEXT,
            qualification TEXT,
            phone TEXT,
            address TEXT,
            email TEXT,
            professional_link TEXT,
            biography TEXT,
            specialization TEXT,
            publications TEXT,
            teaching TEXT,
            research TEXT,
            UNIQUE(name, phone)
        )
    """)

    if os.path.exists(input_file):
        with open(input_file, 'r') as f:
            data = json.load(f)
            
        for item in data:
            cursor.execute("""
                INSERT INTO Faculty (
                    image_url, name, qualification, phone, address, 
                    email, professional_link, biography, specialization, 
                    publications, teaching, research
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT(name, phone) DO UPDATE SET
                image_url = excluded.image_url,
                qualification = excluded.qualification,
                address = excluded.address,
                email = excluded.email,
                biography = excluded.biography,
                specialization = excluded.specialization,
                publications = excluded.publications,
                teaching = excluded.teaching,
                research = excluded.research
        """, (
            item.get('image_url'),
            item.get('name'),
            item.get('qualification'),
            item.get('phone'),
            item.get('address'),
            item.get('email'),
            item.get('professional_link'),
            item.get('biography'),
            item.get('specialization'),
            item.get('publications'),
            item.get('teaching'),
            item.get('research')
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