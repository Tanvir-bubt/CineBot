import 'dart:convert';
import 'package:cinebot/services/movie_service.dart';
import 'package:http/http.dart' as http;
import 'package:cinebot/services/apis.dart'; // for getMovieInfo
class AiService {
  // ------------------ Class-level constants ------------------
  static const String _aiKey = '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';
  static const String _aiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'nvidia/nemotron-nano-12b-v2-vl:free';
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_aiKey',
  };
  static const String _systemContext = """
Your name is CineBot. You reply in warm, short messages.
When user asks for suggestions (anime, movie, tv show etc.), you STRICTLY give the suggestions in this format:
<title> placeholder </title>
<description> a little description of the movie here </description>
""";
  static final List<Map<String, String>> _messages = [];
  static final Map<String, dynamic> _requestMap = {
    'model': _model,
    'max_tokens': 2000,
    'temperature': 0,
    'top_p': 0.9,
    'frequency_penalty': 0.2,
    'presence_penalty': 0.0,
  };




  // ------------------ Private helpers ------------------
  static String _buildRequestBody(String userMessage) {
    if (_messages.isEmpty) {
      _messages.add({
        'role': 'system',
        'content': _systemContext,
      });
    }
    if (_messages.last['role'] == 'user') {
        _messages.removeLast();
    }
    _messages.add({
      'role': 'user',
      'content': userMessage,
    });

    while (_messages.length>7){
      _messages.removeAt(1);
    }
    print(_messages);

    _requestMap['messages'] = _messages;
    return jsonEncode(_requestMap);
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
        if (text.isNotEmpty) result.add({"text": text});
        i = endIndex;
        continue;
      }

      final tagName = match.group(1)!;
      final startContent = match.end;
      final closingTag = '</$tagName>';
      final closingIndex = input.indexOf(closingTag, startContent);
      if (closingIndex == -1) {
        final text = input.substring(match.start).trim();
        if (text.isNotEmpty) result.add({"text": text});
        break;
      }

      final inner = input.substring(startContent, closingIndex).trim();
      if (tagName == "title") {
        result.add({tagName: inner});
        final movieInfo = await MovieService.getMovieInfo(inner);
        result.add({"image": movieInfo["image"] ?? ""});
      } else {
        result.add({tagName: inner});
      }

      i = closingIndex + closingTag.length;
    }

    return result;
  }


  static Future<List<Map<String, String>>> getAiResponse({required String userMessage}) async {
    final body = _buildRequestBody(userMessage);
    try {
      final response = await http.post(Uri.parse(_aiUrl), headers: _headers, body: body);
      if (response.statusCode == 200) {
        final content = jsonDecode(response.body)["choices"]?[0]?["message"]?["content"];
        print(content);
        if (content != null && content is String) {
          _messages.add({
            'role': 'system',
            'content': content,
          });

          return _parseRes(content);
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




}
