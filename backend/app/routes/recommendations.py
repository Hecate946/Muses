from flask import Blueprint, request, jsonify
# from app.services.recommendation_service import get_user_recommendations

recommendations_bp = Blueprint("recommendations", __name__)

@recommendations_bp.route("", methods=["GET"])
def get_recommendations():
    """🎵 Fetch personalized recommendations for a user"""
    user_id = request.args.get("user_id", type=int)
    instrumentation = request.args.get("instrumentation")
    genre = request.args.get("genre")
    composer = request.args.get("composer")

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    # return get_user_recommendations(user_id, instrumentation, genre, composer, top_n=5)

