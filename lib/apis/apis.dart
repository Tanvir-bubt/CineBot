import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:hive/hive.dart';

class Apis {
  static final String aiKey='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';
  static final String aiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static final String model = 'nvidia/nemotron-nano-12b-v2-vl:free';                   // 'openai/gpt-oss-20b:free'
  static final String movie_key = "060a8a925d2fbfb9af161ebefc4d8fac";


  static Future<List<Map<String, String>>> getAiResponse({required String userMessage}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $aiKey',
    };

    final systemContext = """
Your name CineBot that replies in warm and short message.

Do not suggest movies unless user asks for them explicitely.
When the user asks for movie suggestions :
suggest movies based on user's mood (you'll detect that) using ONLY this exact format for each movie:

of course darling, here are your movies:
<movie> Movie1 name here </movie>
description for movie1 as plain text
<movie> Movie2 name here </movie>
description for movie2 as plain text
let me know if they tickle your buds
""";

    final body = jsonEncode({
      'model': model,
      'max_tokens': 200,
      'temperature': 0,
      'top_p': 0.9,
      'frequency_penalty': 0.2,
      'presence_penalty': 0.0,
      'messages': [
        {'role': 'system', 'content': systemContext},
        {'role': 'user', 'content': userMessage},
      ],
    });

    try {
      final response = await http.post(
        Uri.parse(aiUrl),
        headers: headers,
        body: body,
      );

      print("🚨---- AI RESPONSE LOG ----🚨");
      print("Status code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Raw body: ${response.body}");
      print("--------------------------");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final content = decoded["choices"]?[0]?["message"]?["content"];

        if (content != null && content is String) {
          return _parseRes(content); // returns List<Map<String,String>>
        } else {
          return [{"text": "<no content>"}];
        }
      }

      return [
        {"response.statusCode": response.statusCode.toString()},
        {"error": response.body}
      ];
    } catch (e) {
      return [{"error": e.toString()}];
    }
  }


  static Future<List<Map<String, String>>> _parseRes(String input) async {
    final List<Map<String, String>> result = [];
    int i = 0;
    final regex = RegExp(r'<([a-z]+[0-9]*)>');
    while (i < input.length) {
      final match = regex.matchAsPrefix(input, i);
      if (match == null) {
        final nextTagIndex = input.indexOf('<', i);
        final endIndex = nextTagIndex == -1 ? input.length : nextTagIndex;
        final text = input.substring(i, endIndex).trim();
        if (text.isNotEmpty) {
          result.add({"text": text});
        }
        i = endIndex;
        continue;
      }
      final tagName = match.group(1)!;
      final startContent = match.end;
      final closingTag = '</$tagName>';
      final closingIndex = input.indexOf(closingTag, startContent);
      if (closingIndex == -1) {
        final text = input.substring(match.start).trim();
        if (text.isNotEmpty) {
          result.add({"text": text});
        }
        break;
      }
      final inner = input.substring(startContent, closingIndex).trim();
      result.add({tagName: inner});

      // ================= movie =================
      if (tagName == "movie") {
        final movieInfo = await Apis.getMovieInfo(inner);
        result.add({
          "image": movieInfo["image"] ?? "",
          "description": movieInfo["description"] ?? "",
        });
      } else {
        // keep normal tags
        result.add({tagName: inner});
      }

      i = closingIndex + closingTag.length;
    }
    return result;
  }


  static Future<Map<String, String>> getMovieInfo(String query) async {
    final url = Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=$movie_key&query=${Uri.encodeComponent(query)}',);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final movie = data['results'][0];
          return {
            "description": movie['overview'] ?? "<no description>",
            "image": movie['poster_path'] != null
                ? "https://image.tmdb.org/t/p/w500${movie['poster_path']}"
                : "",
          };
        } else {
          return {
            "description": "<not found>",
            "image": "",
          };
        }
      } else {
        return {
          "description": "Status code: ${response.statusCode}",
          "image": "",
        };
      }
    } catch (e) {
      return {
        "description": e.toString(),
        "image": "",
      };
    }
  }

  static String _getBoxName(String flag) {
    switch (flag.toLowerCase()) {
      case 'watch later':
        return 'watch_later';
      case 'watching':
        return 'watching';
      case 'watched':
        return 'watched';
      default:
        throw Exception('Unknown flag: $flag');
    }
  }

  static Future<void> add_to_hive(String movieName, String flag) async {
    final box = Hive.box<String>(_getBoxName(flag));
    if (!box.values.contains(movieName)) {
      await box.add(movieName);
      print("saved movie: $movieName");
    }
  }
  static List<String> get_from_hive(String flag) {
    final box = Hive.box<String>(_getBoxName(flag));
    return box.values.toList();
  }

}
