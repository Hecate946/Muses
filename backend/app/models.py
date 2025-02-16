from app import db

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
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    track_id = db.Column(db.Integer, db.ForeignKey("track.id"), nullable=False)
    action = db.Column(db.String(20), nullable=False)  # 'like', 'skip', 'listen'
