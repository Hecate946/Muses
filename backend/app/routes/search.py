import requests
from flask import Blueprint, request, jsonify

search_bp = Blueprint("search", __name__)

MUSICBRAINZ_API = "https://musicbrainz.org/ws/2/work"

def fetch_musicbrainz_data(query, limit=10):
    """Helper function to query MusicBrainz."""
    params = {"query": query, "fmt": "json", "limit": limit}
    response = requests.get(MUSICBRAINZ_API, params=params)

    if response.status_code == 200:
        works = response.json().get("works", [])
        return [
            {
                "track_id": work.get("id", "unknown-id"),
                "title": work.get("title", "Unknown"),
                "composer": work.get("composer", {}).get("name", "Unknown Composer"),
                "instrumentation": work.get("instrumentation", "Unknown"),
                "genres": [genre["name"] for genre in work.get("genres", [])],
            }
            for work in works
        ]
    else:
        return None

# ✅ 1. Search by Instrumentation
@search_bp.route("/musicbrainz/instrument", methods=["GET"])
def search_by_instrument():
    instrument = request.args.get("instrument", "piano")
    limit = request.args.get("limit", 10)

    query = f"instrumentation:{instrument} OR tag:{instrument}"
    data = fetch_musicbrainz_data(query, limit)

    if data is None:
        return jsonify({"error": "Failed to fetch data"}), 500

    return jsonify(data)

# ✅ 2. Search by Genre
@search_bp.route("/musicbrainz/genre", methods=["GET"])
def search_by_genre():
    genre = request.args.get("genre", "classical")
    limit = request.args.get("limit", 10)

    query = f"tag:{genre}"
    data = fetch_musicbrainz_data(query, limit)

    if data is None:
        return jsonify({"error": "Failed to fetch data"}), 500

    return jsonify(data)

# ✅ 3. Search by Composer
@search_bp.route("/musicbrainz/composer", methods=["GET"])
def search_by_composer():
    composer = request.args.get("composer", "Mozart")
    limit = request.args.get("limit", 10)

    query = f"artist:{composer} AND type:work"
    data = fetch_musicbrainz_data(query, limit)

    if data is None:
        return jsonify({"error": "Failed to fetch data"}), 500

    return jsonify(data)

# ✅ 4. Search for a Single Song by Name
@search_bp.route("/musicbrainz/song", methods=["GET"])
def search_by_song():
    song_name = request.args.get("name")
    if not song_name:
        return jsonify({"error": "Missing song name"}), 400

    query = f"work:{song_name}"
    data = fetch_musicbrainz_data(query, 1)

    if data is None:
        return jsonify({"error": "Failed to fetch data"}), 500

    return jsonify(data[0] if data else {"message": "No results found"})
