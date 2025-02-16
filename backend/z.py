import requests
import time

now = time.time()
response = requests.get("http://localhost:5000/playback/youtube/audio", params={
    "track": ["Bohemian Rhapsody Queen", "Shape of You Ed Sheeran", "Beethoven Symphony 9"]
})

print(response.json())
print(time.time() - now)

now = time.time()

response = requests.get("http://localhost:5000/playback/youtube/audio", params={
    "track": ["Bohemian Rhapsody Queen", "Shape of You Ed Sheeran", "Beethoven Symphony 9"]
})

print(response.json())

print(time.time() - now)
