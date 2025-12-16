import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple TMDB service. Replace YOUR_TMDB_KEY with your key.
class MovieService {
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

  static Future<Map<String, String>> getMovieInfo(String query) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/multi?query=${Uri.encodeComponent(query)}&api_key=$_apiKey',
    );

    try {
      final response = await http.get(url);
      print("Raw API response: ${response.body}"); // see everything

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final movie = data['results'][0];
          final posterPath = movie['poster_path'];

          // just print for checking
          print("Poster path: $posterPath");
          if (posterPath != null) {
            print("Full image URL: https://image.tmdb.org/t/p/w500$posterPath");
          } else {
            print("No poster found for this movie");
          }

          return {
            "description": movie['overview'] ?? "<no description>",
            "image": posterPath != null ? "https://image.tmdb.org/t/p/w500$posterPath" : "",
          };
        } else {
          print("No results found for query: $query");
          return {"description": "<not found>"};
        }
      } else {
        print("API returned status code: ${response.statusCode}");
        return {"description": "Status code: ${response.statusCode}"};
      }
    } catch (e) {
      print("Error occurred: $e");
      return {"description": e.toString()};
    }
  }
}
