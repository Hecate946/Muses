-- Tracks Table
CREATE TABLE tracks (
    track_id TEXT PRIMARY KEY,  -- Unique identifier for the track
    track_name TEXT NOT NULL,  -- Name of the track
    yt_track_name TEXT,  -- Name of the track on YouTube (if different)
    yt_track_id TEXT UNIQUE,  -- YouTube track ID
    audio_url TEXT NOT NULL,  -- URL for the track's audio file
    thumbnail_url TEXT,  -- URL for the track's thumbnail
    video_url TEXT,  -- URL for the video
);

-- Users Table
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique user ID
    username TEXT UNIQUE NOT NULL,  -- Username
    password_hash TEXT NOT NULL  -- Hashed password
);

-- Listens Table (Tracks user listening history)
CREATE TABLE listens (
    track_id TEXT NOT NULL,  -- Track being listened to
    user_id INTEGER NOT NULL,  -- User listening to the track
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Time when listening started
    end_time TIMESTAMP,  -- Time when listening ended
    FOREIGN KEY (track_id) REFERENCES tracks (track_id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Likes Table (Tracks user likes)
CREATE TABLE likes (
    user_id INTEGER NOT NULL,  -- User who liked the track
    track_id TEXT NOT NULL,  -- Track that was liked
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Time when the track was liked
    PRIMARY KEY (user_id, track_id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (track_id) REFERENCES tracks (track_id)
);

-- Saves Table (Tracks user saves)
CREATE TABLE saves (
    user_id INTEGER NOT NULL,  -- User who saved the track
    track_id TEXT NOT NULL,  -- Track that was saved
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Time when the track was saved
    PRIMARY KEY (user_id, track_id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (track_id) REFERENCES tracks (track_id)
);

-- Lesson Plans Table
CREATE TABLE lesson_plans (
    user_id INTEGER NOT NULL,  -- User who created the lesson plan
    track_id TEXT NOT NULL,  -- Track associated with the lesson plan
    content TEXT NOT NULL,  -- Content of the lesson plan
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Time when the lesson plan was created
    PRIMARY KEY (user_id, track_id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (track_id) REFERENCES tracks (track_id)
);
