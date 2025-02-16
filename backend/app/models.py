from app import db
from datetime import datetime

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

class Track(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    instrumentation = db.Column(db.String(255), nullable=False)
    source = db.Column(db.String(255), nullable=False)

class Interaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)  # Foreign key for users
    track_id = db.Column(db.Integer, db.ForeignKey("track.id"), nullable=False)  # Foreign key for tracks
    action = db.Column(db.String(20), nullable=False)  # 'like' or 'scroll'
    start_time = db.Column(db.DateTime, nullable=True, default=datetime.utcnow)
    end_time = db.Column(db.DateTime, nullable=True)

    # Relationships
    user = db.relationship("User", backref="interactions")
    track = db.relationship("Track", backref="interactions")

    def __init__(self, user_id, track_id, action, start_time=None, end_time=None):
        self.user_id = user_id
        self.track_id = track_id
        self.action = action
        self.start_time = start_time or datetime.utcnow()
        self.end_time = end_time
