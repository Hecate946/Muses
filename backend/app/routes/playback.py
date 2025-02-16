from flask import Blueprint, jsonify

playback_bp = Blueprint("playback", __name__)

@playback_bp.route("/", methods=["GET"])
def get_playback():
    return jsonify({"message": "Playback link logic pending"})
