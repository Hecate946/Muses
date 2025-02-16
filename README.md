# Muses - Music Learning Platform

Muses is a modern, interactive music learning platform that helps users discover and learn music through an engaging interface. Named after the Greek muse of music, Euterpe combines powerful music recommendation algorithms with an intuitive learning experience.

## Features

- 🎵 Interactive music discovery feed
- 💖 Like and save favorite tracks
- 🎯 Personalized music recommendations
- 👤 User profiles with learning history
- 📱 Responsive mobile-first design
- 🔄 Continuous playback queue

## Tech Stack

### Backend (Python)
- Flask web framework
- SQLAlchemy ORM
- PostgreSQL database
- RESTful API architecture
- YouTube API integration

### Frontend (Flutter/Dart)
- Flutter framework for cross-platform development
- Provider for state management
- HTTP package for API communication
- SharedPreferences for local storage
- Custom UI components

## Project Structure

```
euterpe/
├── backend/
│   ├── app/
│   │   ├── models/        # Database models
│   │   ├── routes/        # API endpoints
│   │   └── utils/         # Helper functions
│   ├── config.py          # Configuration settings
│   ├── requirements.txt   # Python dependencies
│   ├── seed_database.py   # Database seeding script
│   └── server.py         # Main server file
│
└── frontend/
    └── lib/
        ├── components/    # Reusable UI components
        ├── providers/     # State management
        ├── screens/       # App screens
        ├── services/      # API services
        └── main.dart     # Entry point
```

## Getting Started

### Backend Setup

1. Create a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

3. Set up the database:
   ```bash
   python seed_database.py
   ```

4. Start the server:
   ```bash
   python server.py
   ```

### Frontend Setup

1. Install Flutter dependencies:
   ```bash
   cd frontend
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## API Endpoints

- `POST /auth/register` - Register new user
- `POST /auth/login` - User login
- `POST /interactions/like` - Like a track
- `POST /interactions/unlike` - Unlike a track
- `GET /recommendations` - Get personalized recommendations
- `GET /saved-songs` - Get user's saved songs

## Contributing

2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing cross-platform framework
- Flask team for the lightweight WSGI web application framework
- All contributors who have helped shape this project