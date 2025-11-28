import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple TMDB service. Replace YOUR_TMDB_KEY with your key.
class TMDBService {
  static const _apiKey = "40e7884ceab9461aaa67f63638459e60";
  static const _base = "https://api.themoviedb.org/3";

  /// Returns list of movie maps for trending movies (day)
  static Future<List<dynamic>> getTrendingMovies() async {
    final url = "$_base/trending/movie/day?api_key=$_apiKey";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List);
    }
    throw Exception("Failed to load trending movies");
  }

  /// Returns list of tv maps for trending tv (day)
  static Future<List<dynamic>> getTrendingTV() async {
    final url = "$_base/trending/tv/day?api_key=$_apiKey";
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body)['results'] as List);
    }
    throw Exception("Failed to load trending tv");
  }
}
