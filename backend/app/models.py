from app import db
from datetime import datetime
from flask_bcrypt import generate_password_hash, check_password_hash

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    
    listens = db.relationship('Listen', backref='user', lazy=True)
    liked_songs = db.relationship('Like', backref='user', lazy=True)
    saved_songs = db.relationship('Save', backref='user', lazy=True)
    lesson_plans = db.relationship('LessonPlan', backref='user', lazy=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password).decode("utf-8")

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

class Track(db.Model):
    track_id = db.Column(db.String, primary_key=True)
    track_name = db.Column(db.String(255), nullable=False)
    yt_track_name = db.Column(db.String(255))
    yt_track_id = db.Column(db.String(255), unique=True)
    audio_url = db.Column(db.String(255), nullable=False)
    thumbnail_url = db.Column(db.String(255))
    video_url = db.Column(db.String(255))
    view_count = db.Column(db.Integer, default=0)
    like_count = db.Column(db.Integer, default=0)
    duration = db.Column(db.Integer, nullable=False)
    
    listens = db.relationship('Listen', backref='track', lazy=True)
    liked_by = db.relationship('Like', backref='track', lazy=True)
    saved_by = db.relationship('Save', backref='track', lazy=True)
    lesson_plans = db.relationship('LessonPlan', backref='track', lazy=True)

class Listen(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    track_id = db.Column(db.String, db.ForeignKey('track.track_id'), nullable=False)
    start_time = db.Column(db.DateTime, default=datetime.utcnow)
    end_time = db.Column(db.DateTime, nullable=True)
    
    @property
    def duration(self):
        if self.end_time:
            return (self.end_time - self.start_time).total_seconds()
        return 0

class Like(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    track_id = db.Column(db.String, db.ForeignKey('track.track_id'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

class Save(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    track_id = db.Column(db.String, db.ForeignKey('track.track_id'), nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

class LessonPlan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    track_id = db.Column(db.String, db.ForeignKey('track.track_id'), nullable=False)
    content = db.Column(db.Text, nullable=False)
    created_on = db.Column(db.DateTime, default=datetime.utcnow)
