from flask import Blueprint, request, jsonify
from app.utils.youtube_utils import get_youtube_audio_data

playback_bp = Blueprint("playback", __name__)

@playback_bp.route("/youtube/audio", methods=["GET"])
def get_youtube_audio():
    track_title = request.args.get("track")
    if not track_title:
        return jsonify({"error": "Missing track title"}), 400

    audio_data = get_youtube_audio_data(track_title)
    if audio_data:
        return jsonify(audio_data)

    return jsonify({"error": "Could not fetch audio"}), 500
