import streamlit as st
import sqlite3
import os

def local_css(file_name):
    with open(file_name) as f:
        st.markdown(f'<style>{f.read()}</style>', unsafe_allow_html=True)

local_css("style.css") # Load the theme file

# --- 1. Set Title & Placeholder ---
st.title("🔍 Faculty Finder")

# Create a container that we can clear later
status_container = st.empty()

# --- 2. Heavy Resource Loading ---
@st.cache_resource(show_spinner=False)
def load_engine():
    import torch
    from sentence_transformers import SentenceTransformer, util
    
    # Load model and pre-computed embeddings
    model = SentenceTransformer('./local_model_folder')
    embeddings = torch.load('embeddings.pt', weights_only=True)
    return model, embeddings, util

with st.spinner("Loading Pre-trained Semantic Embeddings..."):
    model, faculty_embeddings, util = load_engine()

# --- 3. THE FIX: Wipe the message from the UI ---
status_container.empty() 

# --- 4. Search Interface ---
# Now this is the first thing the user sees after initialization
query = st.text_input("What research area are you interested in?", 
                     placeholder="e.g., Computer vision or Signal processing")

if query:
    import torch
    query_vec = model.encode(query, convert_to_tensor=True)
    cos_scores = util.cos_sim(query_vec, faculty_embeddings)[0]
    
    # Rank results
    top_results = torch.topk(cos_scores, k=3)
    scores = top_results.values.tolist()
    indices = top_results.indices.tolist()
    
    st.subheader("Recommended Faculties:")
    
    # Fetch and display
    conn = sqlite3.connect('faculty_data.db')
    cursor = conn.cursor()
    
    for i in range(len(indices)):
        idx, score = indices[i], scores[i]
        cursor.execute("""
            SELECT name, faculty_type, email, professional_link, address, specialization 
            FROM Faculty WHERE id = ?
        """, (int(idx)+1,))
        
        row = cursor.fetchone()
        
        if row:
            name, f_type, email, p_link, address, interests = row[0:6]
        
            # Handle missing address
            if not address or address.strip().lower() == "none":
                address_html = ""
            else:
                address_html = f' | <span class="address-text">📍 {address}</span>'

            faculty_html = f"""
<div class="faculty-card">
<h4>{i+1}. {name}</h4>

<p>
<span class="faculty-type">{f_type}</span>{address_html}

</p>

<p>🔗 <a href="{p_link}" target="_blank">
View Institutional Profile</a></p>

<div class="email-label">OFFICIAL EMAIL</div>
<div class="email-box">{email}</div>

<div class="specialization-box">
<strong>Research Specialization:</strong> {interests}
</div>

<div class="score-text">
Match Confidence Score: {score:.2%}
</div>
</div>
"""

            st.markdown(faculty_html, unsafe_allow_html=True)
            st.write("")
    
    conn.close()
