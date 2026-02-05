import os
import logging

# 1. SET THESE FIRST - Before any other imports
os.environ["TOKENIZERS_PARALLELISM"] = "false"
os.environ["HF_HUB_DISABLE_PROGRESS_BARS"] = "1"  # Silences weight loading bars
os.environ["TRANSFORMERS_VERBOSITY"] = "error"    # Silences materializing messages

import json
import torch
import time
from sentence_transformers import SentenceTransformer, util

# 2. Silence the internal loggers explicitly
logging.getLogger("transformers").setLevel(logging.ERROR)
logging.getLogger("sentence_transformers").setLevel(logging.ERROR)

# Load the local model

model = SentenceTransformer('./local_model_folder', local_files_only=True)

def get_embeddings(faculty_list, cache_file='embeddings.pt'):
    if os.path.exists(cache_file):
        return torch.load(cache_file)
    
    print("Generating initial embeddings... (One-time cost)")
    corpus = [" ".join([f.get(k, '') for k in ['name', 'specialization', 'teaching', 'research', 'publications', 'biography'] if f.get(k)]) for f in faculty_list]
    # Set show_progress_bar=False to keep the one-time generation quiet
    embeddings = model.encode(corpus, convert_to_tensor=True, show_progress_bar=False)
    torch.save(embeddings, cache_file)
    return embeddings

def search(query_text, data_source='cleaned_data.json', top_k=5):
    start_time = time.time()

    with open(data_source, 'r') as f:
        faculty_list = json.load(f)

    corpus_embeddings = get_embeddings(faculty_list)
    
    # SILENT ENCODING: show_progress_bar=False is critical here
    query_embedding = model.encode(query_text, convert_to_tensor=True, show_progress_bar=False)
    hits = util.semantic_search(query_embedding, corpus_embeddings, top_k=top_k)[0]

    latency_ms = (time.time() - start_time) * 1000

    print(f"\n--- Results for: '{query_text}' (Latency: {latency_ms:.2f} ms) ---")
    for hit in hits:
        faculty = faculty_list[hit['corpus_id']]
        print(f"[{hit['score']:.4f}] {faculty.get('name', 'N/A')}\nLink: {faculty.get('professional_link', 'N/A')}\n")

if __name__ == "__main__":
    while True:
        user_query = input("Enter search query (or type 'exit'): ")
        if user_query.lower() == 'exit': break
        if user_query.strip():
            search(user_query)