import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL", "sqlite:///database/music_discovery.db")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
