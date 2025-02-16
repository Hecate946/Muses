from flask import Blueprint, request, jsonify
from app import db
from app.models import User, Interaction

user_bp = Blueprint("user", __name__, url_prefix="/users")

@user_bp.route("/<int:user_id>/profile", methods=["GET"])
def get_user_profile(user_id):
    """Fetch user profile data including metrics and activity."""
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    # ✅ Compute total interactions
    total_interactions = Interaction.query.filter_by(user_id=user_id).count()

    # ✅ Compute last 5 interactions
    recent_interactions = (
        Interaction.query.filter_by(user_id=user_id)
        .order_by(Interaction.start_time.desc())
        .limit(5)
        .all()
    )

    recent_activity = [
        {
            "track_id": interaction.track_id,
            "action": interaction.action,
            "timestamp": interaction.start_time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        for interaction in recent_interactions
    ]

    return jsonify({
        "user_id": user.id,
        "username": user.username,
        "total_interactions": total_interactions,
        "recent_activity": recent_activity,
    })

@user_bp.route("/<int:user_id>/history", methods=["GET"])
def get_user_history(user_id):
    """Fetch user's learning history."""
    interactions = Interaction.query.filter_by(user_id=user_id).all()
    if not interactions:
        return jsonify([])  # Return empty list if no history

    history = [
        {
            "track_id": interaction.track_id,
            "action": interaction.action,
            "timestamp": interaction.start_time.strftime("%Y-%m-%d %H:%M:%S"),
        }
        for interaction in interactions
    ]

    return jsonify(history)
