import subprocess
import json

def get_youtube_audio_data(query):
    """Fetch YouTube audio URL, title, and uploader using yt-dlp with volume boost."""
    try:
        # Step 1: Search for the first YouTube result
        search_command = [
            "yt-dlp",
            "ytsearch1:" + query,  # Search and get the first result
            "--print-json"
        ]
        search_result = subprocess.run(search_command, capture_output=True, text=True)

        if search_result.returncode == 0:
            video_info = json.loads(search_result.stdout)
            video_url = f"https://www.youtube.com/watch?v={video_info['id']}"

            # Step 2: Extract the best audio format and boost volume using FFmpeg
            audio_command = [
                "yt-dlp",
                "-j",  # Output JSON format
                "--no-playlist",
                "-f", "bestaudio",
                "--postprocessor-args", "ffmpeg:-filter:a volume=2.5",  # 🔥 Boost volume (2.5x)
                video_url
            ]
            audio_result = subprocess.run(audio_command, capture_output=True, text=True)

            if audio_result.returncode == 0:
                audio_info = json.loads(audio_result.stdout)
                return {
                    "title": video_info.get("title"),
                    "uploader": video_info.get("uploader"),
                    "youtube_url": video_url,
                    "audio_url": audio_info.get("url")  # 🔥 Audio URL with boosted volume
                }
        return None
    except Exception as e:
        print(f"Error fetching YouTube audio: {str(e)}")
        return None
