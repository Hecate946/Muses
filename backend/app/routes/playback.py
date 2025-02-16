from flask import Blueprint, request, jsonify
from app.utils.youtube_utils import fetch_video_details
from app import db
from cachetools import LRUCache

playback_bp = Blueprint("playback", __name__)

# ✅ Dictionary of LRU Caches per user (Stores 100 track URLs per user)
USER_CACHES = {}

def get_user_cache(user_id):
    """✅ Returns the user's LRU cache (creates if not exists)."""
    if user_id not in USER_CACHES:
        USER_CACHES[user_id] = LRUCache(maxsize=100)  # Each user gets a cache of 100 songs
    return USER_CACHES[user_id]

@playback_bp.route("/youtube/audio", methods=["GET"])
def get_youtube_audio():
    """Fetch YouTube audio URL, cache per user, and log interaction."""
    user_id = request.args.get("user_id")
    track_id = request.args.get("track_id")  # ✅ Required
    track_name = request.args.get("track_name")  # ✅ Required

    if not user_id or not track_id or not track_name:
        return jsonify({"error": "Missing user_id, track_id, or track_name"}), 400

    user_cache = get_user_cache(user_id)  # ✅ Get user-specific cache
    cache_key = track_id

    # ✅ Check cache first
    if cache_key in user_cache:
        track_data = user_cache[cache_key]
        print(f"✅ User {user_id} Cache hit: {cache_key}")
    else:
        track_data = fetch_video_details(track_name)  # ✅ Fetch full metadata

        if not track_data:
            return jsonify({"error": "Failed to fetch audio"}), 500

        user_cache[cache_key] = track_data  # ✅ Store in cache
        print(f"⚡ User {user_id} Cached: {cache_key}")

    return jsonify(track_data)

@playback_bp.route("/youtube/audio_batch", methods=["POST"])
def get_youtube_audio_batch():
    """✅ Fetch and cache multiple YouTube audio URLs per user using track IDs and names."""
    data = request.json
    print(f"🔍 Received batch request: {data}")  # Debugging: Log request payload

    user_id = data.get("user_id")
    tracks = data.get("tracks")  # ✅ List of objects with track_id and track_name

    if not user_id:
        print("❌ Error: Missing user_id in request.")
        return jsonify({"error": "Missing user_id"}), 400

    user_cache = get_user_cache(user_id)  # ✅ Get user-specific cache
    print(f"🛠 Retrieved cache for user {user_id}.")

    # ✅ If no tracks are provided, generate a new batch
    if not tracks:
        print(f"🔄 No tracks provided. Generating a new batch for user {user_id}.")
        tracks = generate_new_batch(user_id)  # ✅ Function to get new recommended tracks
    else:
        print(f"🎵 Processing {len(tracks)} tracks for user {user_id}.")

    results = []
    for track in tracks:
        track_id = track.get("track_id")
        track_name = track.get("track_name")

        if not track_id or not track_name:
            print(f"⚠️ Skipping invalid track: {track}")
            continue  # Skip invalid entries

        print(f"🔍 Processing track {track_id}: {track_name}")

        cache_key = track_id

        if cache_key in user_cache:
            video_details = user_cache[cache_key]
            print(f"✅ Cache hit for {cache_key}, using cached details.")
        else:
            print(f"🚀 Fetching video details for {track_name} (ID: {track_id})...")
            video_details = fetch_video_details(track_name)  # ✅ Fetch full details

            if not video_details:
                print(f"❌ Failed to retrieve details for track: {track_name}")
                continue  # Skip this track if fetch failed

            user_cache[cache_key] = video_details  # ✅ Store in user cache
            print(f"⚡ Cached video details for {cache_key}.")

        print(f"🎼 Adding track {track_name} to results...")

        results.append({
            "track_id": track_id,
            "yt_track_id": video_details.get("yt_track_id", ""),
            "track_name": track_name,
            "yt_track_name": video_details.get("yt_track_name", ""),
            "audio_url": video_details.get("audio_url", ""),
            "thumbnail_url": video_details.get("thumbnail_url", ""),
            "video_url": video_details.get("video_url", ""),
        })

    print(f"✅ Batch processing complete. Returning {len(results)} results.")

    return jsonify({"songs": results})


import random

def generate_new_batch(user_id):
    """✅ Generates a new batch of recommended tracks for the user."""
    sample_songs = [
        {"track_id": "b12345-6789", "track_name": "Imagine"},
        {"track_id": "c98765-4321", "track_name": "Bohemian Rhapsody"},
        {"track_id": "x11111-2222", "track_name": "Moonlight Sonata"},
        {"track_id": "z22222-3333", "track_name": "Clair de Lune"},
        {"track_id": "m54321-9999", "track_name": "Shape of You"},
        {"track_id": "a88888-7777", "track_name": "Fur Elise"},
        {"track_id": "t55555-6666", "track_name": "Nocturne Op.9 No.2"},
        {"track_id": "g33333-4444", "track_name": "Hallelujah"},
    ]

    return random.sample(sample_songs, k=min(5, len(sample_songs)))  # ✅ Return 5 random tracks
