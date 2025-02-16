import random
from flask import Blueprint, request, jsonify

recommendations_bp = Blueprint("recommendations", __name__)

# 🎵 Possible values for random recommendations
INSTRUMENTS = ["Piano", "Violin", "Cello", "Flute", "Trumpet", "Clarinet", "Guitar", "Harp"]
GENRES = ["Classical", "Jazz", "Rock", "Electronic", "Folk", "Hip-Hop", "Blues", "Experimental"]
COMPOSERS = ["Beethoven", "Mozart", "Bach", "Chopin", "Debussy", "Tchaikovsky", "Vivaldi", "Ravel"]

def get_random_choice(options, given_value):
    """Returns the given value if provided, otherwise a random choice from the list."""
    return given_value if given_value else random.choice(options)

@recommendations_bp.route("", methods=["GET"])
def get_recommendations():
    """🎵 Fetch personalized recommendations for a user with randomized options if not provided."""
    user_id = request.args.get("user_id", type=int)
    instrumentation = request.args.get("instrumentation")
    genre = request.args.get("genre")
    composer = request.args.get("composer")

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    # ✅ If missing, pick a random instrumentation, genre, or composer
    instrumentation = get_random_choice(INSTRUMENTS, instrumentation)
    genre = get_random_choice(GENRES, genre)
    composer = get_random_choice(COMPOSERS, composer)

    # ✅ Log selected values for debugging
    print(f"🎼 Generating recommendations for user {user_id}:")
    print(f"  🎹 Instrumentation: {instrumentation}")
    print(f"  🎶 Genre: {genre}")
    print(f"  🎼 Composer: {composer}")

    # 🔥 Mock recommendations (Replace this with actual recommendation logic)
    recommendations = [
        {
            "track_id": f"track_{random.randint(1000, 9999)}",
            "track_name": f"{random.choice(['Sonata', 'Concerto', 'Etude', 'Prelude'])} in {random.choice(['C', 'D', 'E', 'F', 'G', 'A', 'B'])} {random.choice(['Major', 'Minor'])}",
            "instrumentation": instrumentation,
            "genre": genre,
            "composer": composer,
            "audio_url": f"https://example.com/audio/{random.randint(1000, 9999)}",
            "thumbnail_url": f"https://example.com/thumbnail/{random.randint(1000, 9999)}.jpg",
        }
        for _ in range(5)  # ✅ Generate 5 random recommendations
    ]

    return jsonify({"recommendations": recommendations})
