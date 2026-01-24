import sqlite3, json, os, argparse

def run_storage(input_file, db_path):
    if not os.path.exists(input_file):
        print(f"No cleaned data found at {input_file} to store.")
        return

    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        print(f"Initializing Schema in {db_path}...")

        # Keep your existing table creation with the UNIQUE constraint
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS Faculty (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                faculty_type TEXT, name TEXT, email TEXT, phone TEXT,
                professional_link TEXT, address TEXT, qualification TEXT,
                specialization TEXT, teaching TEXT, research TEXT,
                publications TEXT, biography TEXT,
                UNIQUE(name, phone)
            )
        """)

        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # Build the data list for bulk insertion
        faculty_data = []
        for item in data:
            faculty_data.append((
                item.get('faculty_type'), item.get('name'), item.get('email'),
                item.get('phone'), item.get('professional_link'), item.get('address'),
                item.get('qualification'), item.get('specialization'), item.get('teaching'),
                item.get('research'), item.get('publications'), item.get('biography')
            ))

        # Use INSERT OR IGNORE to strictly prevent duplicates
        query = """
            INSERT OR IGNORE INTO Faculty (
                faculty_type, name, email, phone, professional_link, 
                address, qualification, specialization, teaching,
                research, publications, biography
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        
        cursor.executemany(query, faculty_data)
        conn.commit() # Commit ONCE at the end for the whole batch
        print(f"Storage Complete: {len(data)} items processed. Final records persisted in {db_path}.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", default="cleaned_data.json")
    parser.add_argument("--database", default="faculty_data.db")
    args = parser.parse_args()
    run_storage(args.input, args.database)
