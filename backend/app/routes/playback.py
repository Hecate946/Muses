from flask import Blueprint, request
from app.utils.youtube_utils import get_audio_url

playback_bp = Blueprint("playback", __name__)

@playback_bp.route("/youtube/audio", methods=["GET"])
def get_youtube_audio():
    track_name = request.args.get("track")

    print(f"🎵 Received request for track: {track_name}")

    if not track_name:
        return {"error": "Missing track name"}, 400

    # ✅ Return the streaming response directly
    return get_audio_url(track_name)
