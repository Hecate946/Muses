from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import Config
import os

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Load configuration from config.py
    app.config.from_object(Config)

    # Ensure database directory exists
    db_path = app.config["SQLALCHEMY_DATABASE_URI"].replace("sqlite:///", "")
    db_dir = os.path.dirname(db_path)
    if not os.path.exists(db_dir):
        os.makedirs(db_dir)

    # Initialize database
    db.init_app(app)

    # Import models before creating tables
    from app import models  # Ensure models are registered

    # Auto-create tables if they don’t exist
    with app.app_context():
        print("🔍 Checking database tables...")
        db.create_all()  # Ensures all models create tables
        print("✅ All tables are created.")

    # Import and register blueprints **after initializing Flask** to avoid circular imports
    from app.routes.search import search_bp
    from app.routes.recommendations import recommendations_bp
    from app.routes.playback import playback_bp
    from app.routes.interactions import interactions_bp

    app.register_blueprint(search_bp, url_prefix="/search")
    app.register_blueprint(recommendations_bp, url_prefix="/recommendations")
    app.register_blueprint(playback_bp, url_prefix="/playback")
    app.register_blueprint(interactions_bp, url_prefix="/interactions")

    return app
