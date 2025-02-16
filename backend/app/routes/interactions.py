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

@interactions_bp.route("/unlike", methods=["POST"])
def unlike_track():
    """Remove a 'like' action for a track."""
    data = request.json
    user_id = data.get("user_id")
    track_id = data.get("track_id")

    if not user_id or not track_id:
        return jsonify({"error": "Missing user_id or track_id"}), 400

    # Find and delete the like interaction
    like = Interaction.query.filter_by(
        user_id=user_id,
        track_id=track_id,
        action="like"
    ).first()

    if like:
        db.session.delete(like)
        db.session.commit()
        return jsonify({"message": "Track unliked"})
    else:
        return jsonify({"error": "Like not found"}), 404


@interactions_bp.route("/like/status", methods=["GET"])
def check_like_status():
    """Check if a track is liked by a user."""
    user_id = request.args.get("user_id")
    track_id = request.args.get("track_id")

    if not user_id or not track_id:
        return jsonify({"error": "Missing user_id or track_id"}), 400

    # Check if a like interaction exists
    like = Interaction.query.filter_by(
        user_id=user_id,
        track_id=track_id,
        action="like"
    ).first()

    return jsonify({"is_liked": like is not None})

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

