from flask import Blueprint, request, jsonify
from app import db
from app.models import Interaction

saved_songs_bp = Blueprint("saved_songs", __name__)

@saved_songs_bp.route("/", methods=["POST"])
def save_song():
    """Save a song to the user's favorites."""
    data = request.json
    user_id = data.get("user_id")
    track_id = data.get("track_id")

    if not user_id or not track_id:
        return jsonify({"error": "Missing user_id or track_id"}), 400

    new_interaction = Interaction(user_id=user_id, track_id=track_id, action="like")
    db.session.add(new_interaction)
    db.session.commit()

    return jsonify({"message": "Song saved"})


@saved_songs_bp.route("/", methods=["GET"])
def get_saved_songs():
    """Return user's saved songs."""
    user_id = request.args.get("user_id")

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    saved_songs = Interaction.query.filter_by(user_id=user_id, action="like").all()
    return jsonify([{"track_id": song.track_id} for song in saved_songs])
