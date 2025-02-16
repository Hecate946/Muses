import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicCard extends StatefulWidget {
  final dynamic musicData;
  final ApiService apiService;

  MusicCard({required this.musicData, required this.apiService});

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  bool isSaved = false;

  void _launchURL(String url) async {
    print('Attempting to launch URL: "$url"');
    
    if (url.isEmpty) {
      print('Error: Empty URL');
      return;
    }

    // Ensure URL starts with http:// or https://
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    try {
      final Uri uri = Uri.parse(url);
      print('Parsed URI: $uri');
      
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String thumbnailUrl = widget.musicData["thumbnail_url"] ?? "";
    String videoUrl = widget.musicData["video_url"] ?? "";
    print('Video URL from musicData: "$videoUrl"');
    String trackName = widget.musicData["track_name"] ?? "Unknown Title";

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Color(0xFFFFF5E1), // Warm cream background
      ),
      child: Column(
        children: [
          // Spacer to move thumbnail lower
          Spacer(),

          // Centered YouTube Thumbnail with shadow
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.22, // Adjusted height
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: thumbnailUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(thumbnailUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Track Name
          Text(
            trackName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),

          // Favorite & Save Icons with Slow Animation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Favorite Icon
              AnimatedContainer(
                duration: Duration(milliseconds: 400), // Slower animation
                curve: Curves.easeInOut,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black54,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    if (isFavorite) {
                      widget.apiService.likeTrack(widget.musicData["track_id"], widget.musicData["track_name"]);
                    }
                  },
                ),
              ),

              SizedBox(width: 20),

              // Save to Learn Icon
              AnimatedContainer(
                duration: Duration(milliseconds: 400), // Slower animation
                curve: Curves.easeInOut,
                child: IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.green : Colors.black54,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      isSaved = !isSaved;
                    });
                    print(isSaved ? "Saved to Learn" : "Removed from Learn List");
                  },
                ),
              ),
            ],
          ),

          Spacer(), // Pushes the link to the bottom

          // Clickable YouTube Link at Bottom
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL(videoUrl),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black26, width: 1.5),
                  ),
                ),
                width: double.infinity,
                child: Text(
                  "🎬 Watch on YouTube",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
