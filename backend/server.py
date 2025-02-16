import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import Config  # Import the Config class

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    
    # Load configuration from config.py
    app.config.from_object(Config)

    # Ensure the database directory exists
    DB_DIR = os.path.dirname(Config.SQLALCHEMY_DATABASE_URI.replace("sqlite:///", ""))
    if not os.path.exists(DB_DIR):
        os.makedirs(DB_DIR)

    db.init_app(app)

    with app.app_context():
        db.create_all()  # Ensure tables exist
        print("Database ready.")

    # Import and register blueprints
    from app.routes.interactions import interactions_bp
    from app.routes.search import search_bp
    from app.routes.playback import playback_bp
    from app.routes.recommendations import recommendations_bp

    app.register_blueprint(interactions_bp, url_prefix="/interactions")
    app.register_blueprint(search_bp, url_prefix="/search")
    app.register_blueprint(playback_bp, url_prefix="/playback")
    app.register_blueprint(recommendations_bp, url_prefix="/recommendations")

    # Ensure clean DB session before and after each request
    @app.before_request
    def before_request():
        if not db.session.is_active:
            db.session.rollback()

    @app.teardown_appcontext
    def shutdown_session(exception=None):
        db.session.remove()

    return app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)
