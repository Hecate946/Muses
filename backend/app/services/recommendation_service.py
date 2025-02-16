import numpy as np
import pandas as pd
from flask import jsonify
from app.models import Interaction, Track
from sklearn.decomposition import TruncatedSVD
from gensim.models import Word2Vec
import networkx as nx

def get_user_recommendations(user_id, instrumentation=None, genre=None, composer=None, top_n=10):
    """🔍 Generates music recommendations using ML-based filtering"""

    # Fetch all user interactions
    interactions = Interaction.query.all()
    track_data = Track.query.all()

    if not interactions or not track_data:
        return jsonify({"error": "No data available"}), 500

    # Convert interactions into a DataFrame
    interaction_df = pd.DataFrame([(i.user_id, i.track_id, i.action) for i in interactions],
                                  columns=["user_id", "track_id", "action"])

    # Convert track metadata into a DataFrame
    track_df = pd.DataFrame([(t.id, t.title, t.instrumentation, t.source) for t in track_data],
                            columns=["track_id", "title", "instrumentation", "source"])

    # 🔥 **1. Matrix Factorization (Collaborative Filtering - SVD)**
    pivot_table = interaction_df.pivot_table(index='user_id', columns='track_id', aggfunc='size', fill_value=0)
    svd = TruncatedSVD(n_components=10)
    latent_matrix = svd.fit_transform(pivot_table)
    user_vector = latent_matrix[user_id] if user_id in pivot_table.index else np.zeros(10)

    track_scores = np.dot(latent_matrix, user_vector)
    track_recommendations = list(pivot_table.columns[np.argsort(-track_scores)][:top_n])

    # 🔥 **2. Graph-Based Learning (Node2Vec for Similar Tracks)**
    G = nx.Graph()
    for _, row in interaction_df.iterrows():
        G.add_edge(f"user_{row.user_id}", f"track_{row.track_id}")

    node2vec_model = Word2Vec([[str(n) for n in G.neighbors(node)] for node in G.nodes()],
                              vector_size=10, window=5, min_count=1, sg=1)

    similar_tracks = []
    for track in track_recommendations:
        try:
            similar_tracks += [int(t.replace("track_", "")) for t, _ in node2vec_model.wv.most_similar(f"track_{track}", topn=3)]
        except KeyError:
            continue

    # 🔥 **3. Apply User's Instrumentation/Genre/Composer Filters**
    filtered_tracks = track_df[
        (track_df["instrumentation"] == instrumentation if instrumentation else True) &
        (track_df["source"] == genre if genre else True)
    ]["track_id"].tolist()

    final_recommendations = list(set(track_recommendations + similar_tracks) & set(filtered_tracks))

    # 🔥 **Return top N results**
    recommended_songs = track_df[track_df["track_id"].isin(final_recommendations)].to_dict(orient="records")
    return jsonify({"recommendations": recommended_songs})
