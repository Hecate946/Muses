from flask import Blueprint, request, jsonify
from app import db
from app.models import Interaction

interactions_bp = Blueprint("interactions", __name__)

@interactions_bp.route("/like", methods=["POST"])
def like_track():
    """Log a 'like' action for a track."""
    data = request.json
    user_id = data.get("user_id")
    track_id = data.get("track_id")

    if not user_id or not track_id:
        return jsonify({"error": "Missing user_id or track_id"}), 400

    like = Interaction(user_id=user_id, track_id=track_id, action="like")
    db.session.add(like)
    db.session.commit()

    return jsonify({"message": "Track liked"})


@interactions_bp.route("/scroll", methods=["POST"])
def track_scroll():
    """Log scrolling interaction."""
    data = request.json
    user_id = data.get("user_id")
    track_id = data.get("track_id")
    start_time = data.get("start_time")
    end_time = data.get("end_time")

    if not all([user_id, track_id, start_time, end_time]):
        return jsonify({"error": "Missing required fields"}), 400

    scroll = Interaction(user_id=user_id, track_id=track_id, action="scroll", start_time=start_time, end_time=end_time)
    db.session.add(scroll)
    db.session.commit()

    return jsonify({"message": "Scroll recorded"})
