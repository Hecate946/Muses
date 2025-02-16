from flask import Blueprint, request, jsonify
from app import db
from app.models import Track

search_bp = Blueprint("search", __name__)

@search_bp.route("/", methods=["GET"])
def search_music():
    instrument = request.args.get("instrument")
    if not instrument:
        return jsonify({"error": "Instrument required"}), 400

    tracks = Track.query.filter(Track.instrumentation.ilike(f"%{instrument}%")).all()
    return jsonify([{"title": track.title, "instrumentation": track.instrumentation} for track in tracks])
