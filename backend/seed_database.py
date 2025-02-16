from app import create_app, db
from app.models import Track

def seed_database():
    app = create_app()
    with app.app_context():
        # Clear existing tracks
        Track.query.delete()
        
        # Classical music tracks with proper titles and instrumentation
        tracks = [
            {
                'title': 'Symphony No. 40 in G minor',
                'instrumentation': 'Wolfgang Amadeus Mozart - Orchestra',
                'source': 'jgpJVI3tDbY'
            },
            {
                'title': 'Moonlight Sonata',
                'instrumentation': 'Ludwig van Beethoven - Piano',
                'source': 'c1iZXyWLnXg'
            },
            {
                'title': 'Violin Concerto in E major',
                'instrumentation': 'Johann Sebastian Bach - Violin & Orchestra',
                'source': '6JQm5aSjX6g'
            },
            {
                'title': 'String Quartet No. 14 in D minor',
                'instrumentation': 'Franz Schubert - Chamber Ensemble',
                'source': '13ygvpIg-S0'
            },
            {
                'title': 'Brandenburg Concerto No. 3',
                'instrumentation': 'Johann Sebastian Bach - Orchestra',
                'source': 'SaCheA6Njc4'
            },
            {
                'title': 'The Four Seasons - Spring',
                'instrumentation': 'Antonio Vivaldi - Violin & Orchestra',
                'source': 'mFWQgxXM_b8'
            },
            {
                'title': 'Nocturne in E-flat major',
                'instrumentation': 'Frédéric Chopin - Piano',
                'source': 'tV5U8kVYezM'
            },
            {
                'title': 'Symphony No. 5 in C minor',
                'instrumentation': 'Ludwig van Beethoven - Orchestra',
                'source': 'fOk8Tm815lE'
            },
            {
                'title': 'Clair de Lune',
                'instrumentation': 'Claude Debussy - Piano',
                'source': 'ea2WoUtbzuw'
            },
            {
                'title': 'The Nutcracker Suite',
                'instrumentation': 'Pyotr Ilyich Tchaikovsky - Orchestra',
                'source': 'M8J8urC_8Jw'
            }
        ]
        
        # Add tracks to database
        for track_data in tracks:
            track = Track(**track_data)
            db.session.add(track)
        
        # Commit changes
        db.session.commit()
        print("✅ Database seeded with classical music tracks!")

if __name__ == '__main__':
    seed_database()
