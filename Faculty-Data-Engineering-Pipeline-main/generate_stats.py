import sqlite3
import pandas as pd
import sys
import os

# Define ANSI escape codes for professional terminal output
BOLD = "\033[1m"
RESET = "\033[0m"

def generate_db_stats(db_name):
    try:
        if not os.path.exists(db_name):
            raise FileNotFoundError(f"Database '{db_name}' not found.")

        conn = sqlite3.connect(db_name)
        df = pd.read_sql_query("SELECT * FROM Faculty", conn)
        conn.close()

        total = len(df)
        
        # --- Pre-calculate specific metrics for the Summary ---
        # Search Vocabulary from specialization
        vocal_text = " ".join(df['specialization'].fillna('').astype(str))
        total_vocal = len(set(vocal_text.split()))

        # Helper to find valid data count for a specific column
        def get_valid_count(column_name):
            series = df[column_name]
            is_invalid = series.apply(lambda x: x is None or str(x).strip() == "" or "not provided" in str(x).lower())
            return len(df[~is_invalid])

        research_count = get_valid_count('research')

        # --- Print Header and Insights ---
        print(f"\n{BOLD}Database Statistics: {db_name}{RESET}")
        print(f"Total Records: {total} | Total Fields: {len(df.columns)}\n")
        
        print(f"--- {BOLD}Pipeline Quality Insights{RESET} ---")
        print(f"Unique Profiles: {df['name'].nunique()} / {total} ({round(df['name'].nunique()/total*100, 1)}% Unique)")
        print(f"Total Search Vocabulary: {total_vocal} unique academic terms")
        print(f"Highest Data Density: {df['name'].count()/total*100:.1f}% (Name)")
        print(f"Lowest Data Density: {research_count/total*100:.1f}% (Research)\n")

        # --- Table Header with ALL metrics ---
        header = f"| {BOLD}{'Field Name':<18}{RESET} | {BOLD}{'Nulls':<10}{RESET} | {BOLD}{'Density%':<10}{RESET} | {BOLD}{'Avg Word':<10}{RESET} | {BOLD}{'Avg Char':<10}{RESET} | {BOLD}{'Min Char':<10}{RESET} | {BOLD}{'Max Char':<10}{RESET} |"
        sep = f"| {'-'*18} | {'-'*10} | {'-'*10} | {'-'*10} | {'-'*10} | {'-'*10} | {'-'*10} |"
        print(header)
        print(sep)

        for col in df.columns:
            # 1. Identify nulls/placeholders
            is_null = df[col].apply(lambda x: x is None or str(x).strip() == "" or "not provided" in str(x).lower())
            null_count = is_null.sum()
            density = round(((total - null_count) / total) * 100, 1)
            
            # 2. Filter for valid data only
            valid_data = df[~is_null][col]
            
            # 3. Calculate all requested metrics
            word_counts = valid_data.apply(lambda x: len(str(x).split()))
            char_lens = valid_data.apply(lambda x: len(str(x)))

            avg_w = round(word_counts.mean(), 1) if not word_counts.empty else 0
            avg_c = round(char_lens.mean(), 1) if not char_lens.empty else 0
            min_c = char_lens.min() if not char_lens.empty else 0
            max_c = char_lens.max() if not char_lens.empty else 0

            # Print aligned row
            print(f"| {col:<18} | {null_count:<10} | {density:<10} | {avg_w:<10} | {avg_c:<10} | {min_c:<10} | {max_c:<10} |")
        print()

    except Exception as e:
        print(f"ERROR: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python generate_stats.py faculty_data.db")
        sys.exit(1)
    generate_db_stats(sys.argv[1])