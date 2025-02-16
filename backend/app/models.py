from app import db
from datetime import datetime
from flask_bcrypt import generate_password_hash, check_password_hash

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)  # ✅ Store hashed passwords

    def set_password(self, password):
        """✅ Hashes the password before storing it"""
        self.password_hash = generate_password_hash(password).decode("utf-8")

    def check_password(self, password):
        """✅ Checks if the entered password matches the stored hash"""
        return check_password_hash(self.password_hash, password)


class Track(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), nullable=False)
    instrumentation = db.Column(db.String(255), nullable=False)
    source = db.Column(db.String(255), nullable=False)


class Interaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)  # ✅ Foreign key to User
    track_id = db.Column(db.Integer, db.ForeignKey('track.id'), nullable=False)  # ✅ Foreign key to Track
    action = db.Column(db.String(20), nullable=False)  # 'like' or 'scroll'
    start_time = db.Column(db.DateTime, default=datetime.utcnow)
    end_time = db.Column(db.DateTime, nullable=True)
