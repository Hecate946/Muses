import requests
from flask import Blueprint, request, jsonify

search_bp = Blueprint("search", __name__)

MUSICBRAINZ_API = "https://musicbrainz.org/ws/2/work"

@search_bp.route("/musicbrainz", methods=["GET"])
def search_musicbrainz():
    instrument = request.args.get("instrument", "clarinet")  # Default instrument
    limit = request.args.get("limit", 10)  # Limit results

    params = {
        "query": f"instrumentation:{instrument} OR tag:{instrument}",
        "fmt": "json",
        "limit": limit
    }

    response = requests.get(MUSICBRAINZ_API, params=params)
    
    if response.status_code == 200:
        works = response.json().get("works", [])
        track_names = [{"title": work.get("title", "Unknown")} for work in works]
        return jsonify(track_names)

    return jsonify({"error": "Failed to fetch data"}), response.status_code
