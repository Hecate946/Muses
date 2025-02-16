from flask import Blueprint, request, jsonify
import random

recommendations_bp = Blueprint("recommendations", __name__)

# ✅ Sample song database (expand later)
SAMPLE_SONGS = [
    {"title": "Symphony No. 9", "instrumentation": "Orchestra"},
    {"title": "Bohemian Rhapsody", "instrumentation": "Rock"},
    {"title": "Imagine", "instrumentation": "Piano"},
    {"title": "Clair de Lune", "instrumentation": "Piano"},
    {"title": "Hotel California", "instrumentation": "Guitar"},
    {"title": "Moonlight Sonata", "instrumentation": "Piano"},
    {"title": "Stairway to Heaven", "instrumentation": "Rock"},
    {"title": "Eine kleine Nachtmusik", "instrumentation": "Orchestra"},
    {"title": "Shape of You", "instrumentation": "Pop"},
    {"title": "Nocturne Op. 9 No. 2", "instrumentation": "Piano"},
]

@recommendations_bp.route("/", methods=["GET"])
def get_recommendations():
    """Return recommended songs (default 5, configurable)."""
    user_id = request.args.get("user_id")
    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    try:
        num_songs = int(request.args.get("num_songs", 5))  # ✅ Default to 5 songs
    except ValueError:
        return jsonify({"error": "Invalid number of songs"}), 400

    # ✅ Ensure we don't return more songs than available
    num_songs = min(num_songs, len(SAMPLE_SONGS))

    return jsonify(random.sample(SAMPLE_SONGS, num_songs))
