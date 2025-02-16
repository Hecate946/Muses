import requests
from flask import Blueprint, request, jsonify

search_bp = Blueprint("search", __name__)

MUSICBRAINZ_API = "https://musicbrainz.org/ws/2/work"

@search_bp.route("/musicbrainz", methods=["GET"])
def search_musicbrainz():
    instrument = request.args.get("instrument", "clarinet")  # Default instrument
    limit = request.args.get("limit", 20)  # Limit results to avoid large responses

    params = {
        "query": f"instrumentation:{instrument} OR tag:{instrument}",
        "fmt": "json",
        "limit": limit
    }

    response = requests.get(MUSICBRAINZ_API, params=params)
    if response.status_code == 200:
        print("it worked")
        return jsonify(response.json().get("works", []))  # Only return works
    return jsonify({"error": "Failed to fetch data"}), response.status_code
