import yt_dlp
import traceback
import json

def get_audio_url(query):
    """
    Given a search query, use yt-dlp to find the best audio stream URL without downloading.
    Returns a JSON object with {"audio_url": audio_url} or None if extraction fails.
    """
    if not query:
        print("❌ No query provided.")
        return json.dumps({"error": "No query provided."})

    ytdlp_opts = {
        'format': 'bestaudio',
        'noplaylist': True,
        'default_search': 'ytsearch',
        'quiet': True,
    }

    try:
        print(f"🔍 Searching YouTube for: {query}")

        with yt_dlp.YoutubeDL(ytdlp_opts) as ydl:
            info = ydl.extract_info(query, download=False)

        print("✅ yt-dlp successfully retrieved video information.")

        if 'entries' in info:  # If a search returns multiple results, take the first one
            print(f"🔎 Multiple results found. Selecting the first one: {info['entries'][0]['title']}")
            info = info['entries'][0]

        audio_url = info.get('url')

        if not audio_url:
            print("❌ Audio URL not found.")
            return json.dumps({"error": "Audio URL not found."})

        print(f"🎶 Extracted Audio URL: {audio_url}")
        return json.dumps({"audio_url": audio_url})  # Return JSON object

    except Exception as e:
        print(f"❌ Error extracting audio URL: {e}")
        traceback.print_exc()
        return json.dumps({"error": str(e)})  # Return JSON object on failure
