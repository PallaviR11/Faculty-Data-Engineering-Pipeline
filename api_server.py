from fastapi import FastAPI
import sqlite3
import os
from contextlib import asynccontextmanager

DB_NAME = os.getenv("DATABASE_NAME", "faculty_data.db")

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("\n" + "="*50)
    print("DEPIPELINE SERVING LAYER IS LIVE!")
    print(f"Connected to Database: {DB_NAME}")
    print(f"View Faculty Data: http://127.0.0.1:8000/faculty/all")
    print(f"View API Docs:     http://127.0.0.1:8000/docs")
    print("="*50 + "\n")
    yield

app = FastAPI(lifespan=lifespan)

def get_db_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    return conn

@app.get("/faculty/all")
def get_all_faculty():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Faculty")
    rows = cursor.fetchall()
    conn.close()
    return [dict(row) for row in rows]