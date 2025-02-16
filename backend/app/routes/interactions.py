from flask import Blueprint, request, jsonify
from app import db
from app.models import Interaction
from datetime import datetime

interactions_bp = Blueprint("interactions", __name__)

@interactions_bp.route("/like", methods=["POST"])
def like_track():
    data = request.json
    user_id = data.get("user_id")
    track_id = data.get("track_id")

    if not user_id or not track_id:
        return jsonify({"error": "Missing required fields"}), 400

    interaction = Interaction(user_id=user_id, track_id=track_id, action="like")
    db.session.add(interaction)
    db.session.commit()

    return jsonify({"message": "Track liked successfully"}), 200

@interactions_bp.route("/scroll", methods=["POST"])
def track_scroll():
    data = request.json
    user_id = data.get("user_id")
    track_id = data.get("track_id")
    start_time = data.get("start_time")
    end_time = data.get("end_time")

    if not user_id or not track_id or not start_time or not end_time:
        return jsonify({"error": "Missing required fields"}), 400

    interaction = Interaction(
        user_id=user_id,
        track_id=track_id,
        action="scroll",
        start_time=datetime.fromisoformat(start_time),
        end_time=datetime.fromisoformat(end_time)
    )
    db.session.add(interaction)
    db.session.commit()

    return jsonify({"message": "Scroll tracked successfully"}), 200
