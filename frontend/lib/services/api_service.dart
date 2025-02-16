import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/search/musicbrainz";

  Future<List<dynamic>> fetchMusicByInstrument(String instrument) async {
    final url = Uri.parse("$baseUrl?instrument=$instrument");
    print("Sending request to: $url"); // Debugging

    final response = await http.get(url);

    print("Response Code: ${response.statusCode}"); // Debugging
    print("Response Body: ${response.body}"); // Debugging

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch music");
    }
  }
}
