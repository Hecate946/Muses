from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import os

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Load configuration
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL", "sqlite:///database/music_discovery.db")
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    # Initialize extensions
    db.init_app(app)
    Migrate(app, db)

    # Register blueprints
    from app.routes.search import search_bp
    from app.routes.recommendations import recommendations_bp
    from app.routes.playback import playback_bp

    app.register_blueprint(search_bp, url_prefix="/search")
    app.register_blueprint(recommendations_bp, url_prefix="/recommendations")
    app.register_blueprint(playback_bp, url_prefix="/playback")

    return app
