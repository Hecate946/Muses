from flask import Blueprint, jsonify
from app.models import User, Like, Save, Listen, Track

user_bp = Blueprint("user", __name__, url_prefix="/users")

@user_bp.route("/<int:user_id>/profile", methods=["GET"])
def get_user_profile(user_id):
    """Fetch user profile data including total likes, saves, and recent activity."""
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    # Compute total likes and saves
    total_likes = Like.query.filter_by(user_id=user_id).count()
    total_saves = Save.query.filter_by(user_id=user_id).count()


    return jsonify({
        "user_id": user.id,
        "username": user.username,
        "total_likes": total_likes,
        "total_saves": total_saves,
    })

@user_bp.route("/<int:user_id>/history", methods=["GET"])
def get_user_history(user_id):
    """Fetch user's last 10 listened tracks with track details."""
    listens = (
        Listen.query.filter_by(user_id=user_id)
        .order_by(Listen.start_time.desc())
        .limit(10)
        .all()
    )
    
    if not listens:
        return jsonify([])  # Return empty list if no history

    history = []
    for listen in listens:
        track = Track.query.get(listen.track_id)
        if track:
            history.append({
                "track_id": track.track_id,
                "track_name": track.track_name,
                "yt_track_name": track.yt_track_name,
                "yt_track_id": track.yt_track_id,
                "audio_url": track.audio_url,
                "thumbnail_url": track.thumbnail_url,
                "video_url": track.video_url,
                "view_count": track.view_count,
                "like_count": track.like_count,
                "duration": track.duration,
                "timestamp": listen.start_time.strftime("%Y-%m-%d %H:%M:%S"),
            })

    return jsonify(history)

