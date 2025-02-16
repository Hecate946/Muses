import os
import pandas as pd
import numpy as np
from openai import OpenAI
from typing import List, Dict, Any

class RecommendationService:
    def __init__(self):
        # Initialize OpenAI client with API key from environment
        self.client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
        self.model = "text-embedding-ada-002"
        
    def get_embedding(self, text: str) -> List[float]:
        """Get embeddings from OpenAI API"""
        try:
            response = self.client.embeddings.create(
                model=self.model,
                input=[text]
            )
            return response.data[0].embedding
        except Exception as e:
            print(f"Error generating embedding: {e}")
            return None
            
    def get_similar_songs(self, target_song: str, song_list: List[str], top_n: int = 5) -> List[str]:
        """Find similar songs based on embeddings"""
        # Get embedding for target song
        target_embedding = self.get_embedding(target_song)
        if not target_embedding:
            return []
            
        # Get embeddings for all songs
        song_embeddings = []
        for song in song_list:
            embedding = self.get_embedding(song)
            if embedding:
                song_embeddings.append((song, embedding))
                
        # Calculate similarities
        similarities = []
        for song, embedding in song_embeddings:
            similarity = np.dot(target_embedding, embedding) / \
                        (np.linalg.norm(target_embedding) * np.linalg.norm(embedding))
            similarities.append((song, similarity))
            
        # Sort by similarity and return top N
        similarities.sort(key=lambda x: x[1], reverse=True)
        return [song for song, _ in similarities[:top_n]]
        
    def recommend_songs(self, user_data: Dict[str, Any], top_n: int = 5) -> List[str]:
        """Recommend songs based on user's listening history"""
        # Get user's listened songs
        listened_songs = user_data.get('top_ten_most_listened_songs', '').split(';')
        liked_songs = user_data.get('ten_liked_songs', '').split(';')
        saved_songs = user_data.get('ten_saved_songs', '').split(';')
        
        # Combine all unique songs
        all_songs = list(set(listened_songs + liked_songs + saved_songs))
        
        # Get recommendations for each listened song
        recommendations = []
        for song in listened_songs:
            similar_songs = self.get_similar_songs(song, all_songs, top_n=2)
            recommendations.extend(similar_songs)
            
        # Remove duplicates and songs user has already heard
        recommendations = list(dict.fromkeys(recommendations))
        recommendations = [song for song in recommendations 
                          if song not in listened_songs + liked_songs + saved_songs]
                          
        return recommendations[:top_n]

# Function to get embeddings from OpenAI (updated for openai>=1.0.0)
def get_embedding(text, model="text-embedding-ada-002"):
    try:
        response = openai.embeddings.create(
            model=model,
            input=[text]  # Must be a list
        )
        return response.data[0].embedding  # Updated way to access embedding
    except Exception as e:
        print(f"Error generating embedding: {e}")
        return None

# Ensure OpenAI API key is set
openai.api_key = "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"  # Replace with actual API key

# Select the column to embed (e.g., top_ten_most_listened_songs)
df["song_embeddings"] = df["top_ten_most_listened_songs"].apply(lambda x: get_embedding(x) if pd.notna(x) else None)

# Save to CSV (optional)
df.to_csv("muses_users_with_embeddings.csv", index=False)


# Show DataFrame with embeddings
df.head()

import pandas as pd
import os
from google.colab import files

# Define the correct save path
save_path = "muses_users_with_embeddings.csv"  # Saves in the current directory

# Save the DataFrame (ensure `df`

import numpy as np
from google.colab import files

# Convert embeddings column to a NumPy array
embeddings_array = np.array(df["song_embeddings"].tolist())

# Define the correct save path
save_path = "muses_embeddings.npy"

# Save as a NumPy file
np.save(save_path, embeddings_array)

# Download the file
files.download(save_path)

import faiss
from google.colab import files

# Define the correct save path
save_path = "muses_faiss.index"

# Save index
faiss.write_index(index, save_path)

# Download the FAISS index file
files.download(save_path)

import pandas as pd
import numpy as np
import ast  # Safely converts string to list

# Load CSV
csv_path = "muses_users_with_embeddings.csv"
df = pd.read_csv(csv_path)

# Safely convert string embeddings back to lists
def safe_convert(embedding_str):
    try:
        return np.array(ast.literal_eval(embedding_str))  # Use `ast.literal_eval` instead of `np.fromstring`
    except (ValueError, SyntaxError) as e:
        print(f"Error converting embedding: {embedding_str} - {e}")
        return np.zeros(1536)  # Default to zero vector if parsing fails

df["song_embeddings"] = df["song_embeddings"].apply(lambda x: safe_convert(x) if isinstance(x, str) else np.zeros(1536))

# Convert to a NumPy array for faster computation
embeddings_array = np.vstack(df["song_embeddings"].values)

from sklearn.metrics.pairwise import cosine_similarity

# Suppose we have an array of song embeddings (separately generated)
song_embeddings = np.random.rand(50, 1536)  # Example: 50 songs with 1536-dimensional embeddings

# Compute similarity
song_similarity_matrix = cosine_similarity(song_embeddings)

# Convert to DataFrame (assuming song titles are available)
song_titles = [f"Song_{i}" for i in range(50)]
song_similarity_df = pd.DataFrame(song_similarity_matrix, index=song_titles, columns=song_titles)

# Display similarity matrix
song_similarity_df

def get_similar_songs(target_song, top_n=5):
    similar_songs = song_similarity_df[target_song].sort_values(ascending=False)[1:top_n+1]  # Skip self
    return similar_songs.index.tolist()

# Example: Find songs similar to "Song_10"
similar_songs = get_similar_songs("Song_10")
print(f"Songs similar to Song_10: {similar_songs}")

!pip install faiss-cpu

import faiss

# Create FAISS index
index = faiss.IndexFlatL2(embeddings_array.shape[1])  # L2 (Euclidean) distance
index.add(embeddings_array)  # Add user embeddings

# Search for nearest neighbors (top 2 closest users to the first user)
D, I = index.search(np.array([embeddings_array[0]]), k=3)  # Searching for 3 closest users

# Get closest users
closest_users = df.iloc[I[0][1:]]["user_name"].values
print(f"Users most similar to {df.iloc[0]['user_name']}: {closest_users}")

from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

# Compute song similarity matrix (assuming song_embeddings is a dictionary with song titles as keys)
song_titles = df["top_ten_most_listened_songs"].explode().unique()  # Get all unique song titles
song_embeddings = {title: np.random.rand(1536) for title in song_titles}  # Replace with real embeddings

# Convert song embeddings to a matrix
song_embedding_matrix = np.array(list(song_embeddings.values()))
song_similarity_matrix = cosine_similarity(song_embedding_matrix)

# Create a DataFrame for similarity lookup
song_similarity_df = pd.DataFrame(song_similarity_matrix, index=song_titles, columns=song_titles)

def get_similar_songs(target_song, top_n=5):
    """
    Get top N similar songs based on cosine similarity.
    """
    if target_song not in song_similarity_df.index:
        print(f"Warning: Song '{target_song}' not found in similarity matrix. Skipping...")
        return []

    similar_songs = song_similarity_df[target_song].sort_values(ascending=False)[1:top_n+1]  # Skip self
    return similar_songs.index.tolist()

def recommend_songs(target_user, top_n_songs=5):
    """
    Recommend similar songs to those the user has listened to.
    """
    user_songs = df[df["user_name"] == target_user]["top_ten_most_listened_songs"].values[0].split(";")

    # Collect similar songs
    recommended_songs = []
    for song in user_songs:
        similar = get_similar_songs(song, top_n=2)  # Get top 2 similar songs per listened song
        recommended_songs.extend(similar)

    return list(set(recommended_songs))[:top_n_songs]  # Return unique top recommendations

# Get final song recommendations for Dean
final_recommendations = recommend_songs("Dean")
print(f"Recommended Songs for Dean: {final_recommendations}")

# Normalize song titles in DataFrame
df["top_ten_most_listened_songs"] = df["top_ten_most_listened_songs"].apply(lambda x: [s.strip().lower() for s in x.split(";")])

# Normalize song titles in similarity matrix
song_similarity_df.index = song_similarity_df.index.str.strip().str.lower()

from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

# Compute song similarity matrix (assuming song_embeddings is a dictionary with song titles as keys)
song_titles = df["top_ten_most_listened_songs"].explode().unique()  # Get all unique song titles
song_embeddings = {title: np.random.rand(1536) for title in song_titles}  # Replace with real embeddings

# Convert song embeddings to a matrix
song_embedding_matrix = np.array(list(song_embeddings.values()))
song_similarity_matrix = cosine_similarity(song_embedding_matrix)

# Create a DataFrame for similarity lookup
song_similarity_df = pd.DataFrame(song_similarity_matrix, index=song_titles, columns=song_titles)

def get_similar_songs(target_song, top_n=5):
    target_song = target_song.strip().lower()  # Normalize before lookup

    if target_song not in song_similarity_df.index:
        print(f"Warning: Song '{target_song}' not found in similarity matrix. Skipping...")
        return []

    similar_songs = song_similarity_df[target_song].sort_values(ascending=False)[1:top_n+1]  # Skip self
    return similar_songs.index.tolist()

def recommend_songs(target_user, top_n_songs=5):
    """
    Recommend similar songs to those the user has listened to.
    """
    user_songs = df[df["user_name"] == target_user]["top_ten_most_listened_songs"].values[0]  # Remove .split(";")

    # Collect similar songs
    recommended_songs = []
    for song in user_songs:
        similar = get_similar_songs(song, top_n=2)  # Get top 2 similar songs per listened song
        recommended_songs.extend(similar)

    return list(set(recommended_songs))[:top_n_songs]  # Return unique top recommendations

# Get final song recommendations for Dean
final_recommendations = recommend_songs("Dean")
print(f"Recommended Songs for Dean: {final_recommendations}")

