from flask import Blueprint, request, jsonify
from app.utils.youtube_utils import fetch_audio_url
from app import db
from app.models import Interaction
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
    """Fetch YouTube audio URL using track_id and track_name, cache per user, and log interaction."""
    user_id = request.args.get("user_id")
    track_id = request.args.get("track_id")  # ✅ Required
    track_name = request.args.get("track_name")  # ✅ Required

    if not user_id or not track_id or not track_name:
        return jsonify({"error": "Missing user_id, track_id, or track_name"}), 400

    user_cache = get_user_cache(user_id)  # ✅ Get user-specific cache

    # ✅ Cache using track_id (names can be duplicated across different IDs)
    cache_key = track_id

    # ✅ Check cache first
    if cache_key in user_cache:
        audio_url = user_cache[cache_key]
        print(f"✅ User {user_id} Cache hit: {cache_key}")
    else:
        audio_url = fetch_audio_url(track_name)  # ✅ Fetch using track_name

        if not audio_url:
            return jsonify({"error": "Failed to fetch audio"}), 500

        user_cache[cache_key] = audio_url  # ✅ Store in cache using track_id
        print(f"⚡ User {user_id} Cached: {cache_key}")

    # ✅ Log interaction
    new_interaction = Interaction(user_id=user_id, track_id=track_id, action="play")
    db.session.add(new_interaction)
    db.session.commit()

    return jsonify({"track_id": track_id, "track_name": track_name, "audio_url": audio_url})

@playback_bp.route("/youtube/audio_batch", methods=["POST"])
def get_youtube_audio_batch():
    """✅ Fetch and cache multiple YouTube audio URLs per user using track IDs and names."""
    data = request.json
    user_id = data.get("user_id")
    tracks = data.get("tracks")  # ✅ List of objects with track_id and track_name

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    user_cache = get_user_cache(user_id)  # ✅ Get user-specific cache

    # ✅ If no tracks are provided, generate a new batch
    if not tracks:
        print(f"🔄 No tracks provided. Generating a new batch for user {user_id}.")
        tracks = generate_new_batch(user_id)  # ✅ Function to get new recommended tracks

    results = []
    for track in tracks:
        track_id = track.get("track_id")
        track_name = track.get("track_name")

        if not track_id or not track_name:
            continue  # Skip invalid entries

        cache_key = track_id

        if cache_key in user_cache:
            audio_url = user_cache[cache_key]
            print(f"✅ User {user_id} Cache hit: {cache_key}")
        else:
            audio_url = fetch_audio_url(track_name)  # ✅ Fetch using track_name

            if audio_url:
                user_cache[cache_key] = audio_url  # ✅ Store in user cache
                print(f"⚡ User {user_id} Cached: {cache_key}")

        if audio_url:
            results.append({"track_id": track_id, "track_name": track_name, "audio_url": audio_url})

            # ✅ Log interaction
            new_interaction = Interaction(user_id=user_id, track_id=track_id, action="prefetch")
            db.session.add(new_interaction)

    db.session.commit()

    return jsonify({"songs": results})

def generate_new_batch(user_id):
    """✅ Generates a new batch of recommended tracks for the user."""
    sample_songs = [
        {"track_id": "b12345-6789", "track_name": "Imagine"},
        {"track_id": "c98765-4321", "track_name": "Bohemian Rhapsody"},
        {"track_id": "x11111-2222", "track_name": "Moonlight Sonata"},
    ]
    return sample_songs[:5]  # ✅ Return up to 5 new tracks
