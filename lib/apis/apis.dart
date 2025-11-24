import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> getAIResponse({
    required String userMessage,
  }) async {
    const String aiKey ='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';
    const String aiUrl = 'https://openrouter.ai/api/v1/chat/completions';
    const String aiModel = 'openai/gpt-oss-20b:free'; //'nvidia/nemotron-nano-12b-v2-vl:free';
    // System prompt ensures context and optional movie format
    const String systemContext = """
You are CineBot that answers normally.

Do NOT suggest any movies unless the user specifically requests movie suggestions.

When the user DOES ask for movie suggestions:
Respond using ONLY this exact format for each movie:

- <movieTitle> Movie name here </movieTitle>

""";
    final headers ={
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $aiKey",
    };
    final body = jsonEncode({
      "model": aiModel,
      "max_tokens": 200,
      "temperature": 0,
      "top_p": 0.9,
      "frequency_penalty": 0.2,
      "presence_penalty": 0.0,
      "messages": [
        {
          "role": "system",
          "content": systemContext,
        },
        {"role": "user", "content": userMessage}
      ],
    });


    final response = await http.post(
      Uri.parse(aiUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    // Prepare pretty JSON for logging
    final dynamic decoded = jsonDecode(response.body);
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(decoded);
    print("\n\n$prettyJson\n\n");
/*    // Write nicely formatted response to file
    final logFile = File('openrouter_log.json');
    await logFile.writeAsString(
      prettyJson,
      mode: FileMode.write, // or FileMode.append if you prefer
    );*/

    // Return assistant message
    if (response.statusCode == 200) {
      return decoded['choices'][0]['message']['content'];
    } else {
       return "Request failed: ${response.statusCode} — ${response.body}";
    }
}
