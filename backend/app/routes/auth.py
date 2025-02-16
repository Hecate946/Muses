from flask import Blueprint, request, jsonify
from app import db
from app.models import User, Interaction

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def register():
    """Register a new user."""
    data = request.json
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"error": "Missing username or password"}), 400

    existing_user = User.query.filter_by(username=username).first()
    if existing_user:
        return jsonify({"error": "Username already taken"}), 409

    new_user = User(username=username)
    new_user.set_password(password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered", "user_id": new_user.id})


@auth_bp.route("/login", methods=["POST"])
def login():
    """Log in a user."""
    data = request.json
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"error": "Missing username or password"}), 400

    user = User.query.filter_by(username=username).first()

    if not user or not user.check_password(password):
        return jsonify({"error": "Invalid username or password"}), 401

    return jsonify({"message": "Login successful", "user_id": user.id})


@auth_bp.route("/logout", methods=["POST"])
def logout():
    """Logout user. (Handled by frontend, this is just a placeholder)"""
    # TODO: CLEAR USER CACHE HERE
    return jsonify({"message": "User logged out successfully"}), 200


@auth_bp.route("/delete-account", methods=["DELETE"])
def delete_account():
    """Delete a user and their interactions from the database."""
    data = request.json
    user_id = data.get("user_id")

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    user = User.query.get(user_id)

    if not user:
        return jsonify({"error": "User not found"}), 404

    # ✅ Delete interactions first (to avoid foreign key issues)
    Interaction.query.filter_by(user_id=user_id).delete()
    db.session.delete(user)
    db.session.commit()

    return jsonify({"message": "User account deleted successfully"}), 200