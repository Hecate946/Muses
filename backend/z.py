# populate_db.py
from app import db
from app.models import User, Track, Listen, LikedSong, SavedSong
from datetime import datetime, timedelta

def populate_db():
    # Create a sample user
    user = User(username="Dean")
    user.set_password("password")
    db.session.add(user)
    db.session.flush()  # so we have user.id

    # Define some sample tracks (normally these might come from your catalog)
    track_titles = [
        "Blinding Lights", "Shape of You", "Dance Monkey", "Drivers License",
        "Uptown Funk", "Levitating", "Sugar", "Bad Guy", "Señorita", "Closer",
        "Shallow", "Roar", "Rolling in the Deep", "Counting Stars", "Believer",
        "Perfect", "Happier", "Girls Like You", "See You Again", "Sunflower",
        "All of Me", "Sucker", "Love Yourself", "Photograph", "Despacito",
        "Lovely", "Royals", "Cheap Thrills", "Roses", "Don't Start Now"
    ]
    track_dict = {}
    for title in track_titles:
        track = Track(title=title, instrumentation="default", source="populated")
        db.session.add(track)
        db.session.flush()  # to obtain track.id
        track_dict[title.lower()] = track

    # Log some listen events for Dean:
    # (For demonstration, we assume Dean listens to his top songs multiple times.)
    listen_events = [
        ("Blinding Lights", 5),
        ("Shape of You", 3),
        ("Dance Monkey", 4),
        ("Drivers License", 2),
        ("Uptown Funk", 3),
    ]
    for title, count in listen_events:
        for i in range(count):
            listen = Listen(
                user_id=user.id,
                track_id=track_dict[title.lower()].id,
                start_time=datetime.utcnow() - timedelta(minutes=5 * i),
                end_time=datetime.utcnow() - timedelta(minutes=5 * i - 3)  # assume 3-minute listens
            )
            db.session.add(listen)

    # Log some liked songs
    liked_titles = ["Shallow", "Roar", "Counting Stars", "Believer", "Perfect"]
    for title in liked_titles:
        like = LikedSong(user_id=user.id, track_id=track_dict[title.lower()].id)
        db.session.add(like)

    # Log some saved songs
    saved_titles = ["All of Me", "Sucker", "Love Yourself", "Photograph", "Despacito"]
    for title in saved_titles:
        save = SavedSong(user_id=user.id, track_id=track_dict[title.lower()].id)
        db.session.add(save)

    db.session.commit()
    print("Database populated with sample listens, likes, and saves!")

if __name__ == "__main__":
    populate_db()
