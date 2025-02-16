from flask import Blueprint, jsonify

recommendations_bp = Blueprint("recommendations", __name__)

@recommendations_bp.route("/", methods=["GET"])
def get_recommendations():
    return jsonify({"message": "Recommendation logic pending"})
