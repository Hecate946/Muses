import yt_dlp
import traceback
import json


def fetch_video_details(query):
    """
    Given a search query, use yt-dlp to find the best audio stream URL without downloading.
    Returns a JSON object with audio URL, metadata, and video details.
    """
    if not query:
        print("❌ No query provided.")
        return json.dumps({"error": "No query provided."})

    ytdlp_opts = {
        "format": "bestaudio",
        "noplaylist": True,
        "default_search": "ytsearch",
        "quiet": True,
    }

    try:
        print(f"🔍 Searching YouTube for: {query}")

        with yt_dlp.YoutubeDL(ytdlp_opts) as ydl:
            info = ydl.extract_info(query, download=False)

        print("✅ yt-dlp successfully retrieved video information.")

        if "entries" in info:  # If search returns multiple results, take the first one
            print(f"🔎 Multiple results found. Selecting the first one: {info['entries'][0]['title']}")
            info = info["entries"][0]

        # ✅ Extract relevant fields
        audio_url = info.get("url")
        thumbnail_url = info.get("thumbnail")
        video_url = info.get("webpage_url")
        yt_track_id = info.get("id")
        yt_track_name = info.get("title")
        view_count = info.get("view_count", 0)
        like_count = info.get("like_count", 0)
        duration = info.get("duration", 0)  # In seconds

        if not audio_url:
            print("❌ Audio URL not found.")
            return json.dumps({"error": "Audio URL not found."})

        # ✅ Format duration into mm:ss or hh:mm:ss
        formatted_duration = (
            f"{duration // 3600}:{(duration % 3600) // 60:02}:{duration % 60:02}"
            if duration >= 3600
            else f"{(duration % 3600) // 60}:{duration % 60:02}"
        )

        print(f"🎶 Extracted Audio URL: {audio_url}")
        print(f"🖼  Thumbnail: {thumbnail_url}")
        print(f"📺  Video URL: {video_url}")
        print(f"⏳ Duration: {formatted_duration}")
        print(f"👀 Views: {view_count}")
        print(f"👍 Likes: {like_count}")

        return {
                "yt_track_id": yt_track_id,
                "yt_track_name": yt_track_name,
                "audio_url": audio_url,
                "thumbnail_url": thumbnail_url,
                "video_url": video_url,
                "view_count": view_count,
                "like_count": like_count,
                "duration": formatted_duration,
        }
        

    except Exception as e:
        print(f"❌ Error extracting audio URL: {e}")
        traceback.print_exc()
        return json.dumps({"error": str(e)})
