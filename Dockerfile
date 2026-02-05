# Use a lightweight Python image
FROM python:3.10-slim

# Install system dependencies for Scrapy and Curl
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project
COPY . .

# Create directories for logs and models
RUN mkdir -p logs local_model_folder

# Pre-download the SentenceTransformer model during build 
# This ensures Render doesn't time out during the first request
RUN python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2', cache_folder='./local_model_folder')"

# Expose ports (FastAPI on 8000, Streamlit on 8501)
EXPOSE 8000
EXPOSE 8501

# The start command (we will override this in Render)

CMD ["uvicorn", "api_server:app", "--host", "0.0.0.0", "--port", "10000"]
