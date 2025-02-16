from flask import Blueprint, request, jsonify
from app import db
from app.models import Track, User, Listen, Like, Save, LessonPlan

db_bp = Blueprint("db", __name__)

@db_bp.route("/add_track", methods=["POST"])
def add_track():
    data = request.json
    track = Track(**data)
    db.session.add(track)
    db.session.commit()
    return jsonify({"message": "Track added successfully"})

@db_bp.route("/add_user", methods=["POST"])
def add_user():
    data = request.json
    user = User(**data)
    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "User added successfully"})

@db_bp.route("/add_listen", methods=["POST"])
def add_listen():
    data = request.json
    listen = Listen(**data)
    db.session.add(listen)
    db.session.commit()
    return jsonify({"message": "Listen recorded successfully"})

@db_bp.route("/add_like", methods=["POST"])
def add_like():
    data = request.json
    like = Like(**data)
    db.session.add(like)
    db.session.commit()
    return jsonify({"message": "Like recorded successfully"})

@db_bp.route("/add_save", methods=["POST"])
def add_save():
    data = request.json
    save = Save(**data)
    db.session.add(save)
    db.session.commit()
    return jsonify({"message": "Save recorded successfully"})

@db_bp.route("/add_lesson_plan", methods=["POST"])
def add_lesson_plan():
    data = request.json
    lesson_plan = LessonPlan(**data)
    db.session.add(lesson_plan)
    db.session.commit()
    return jsonify({"message": "Lesson plan added successfully"})
