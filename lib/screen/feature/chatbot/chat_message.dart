class ChatMessage {
  final bool isUser;
  final String? text; // for single text message (user or error)
  final List<Map<String, String>>? textList; // for AI messages with multiple tags

  ChatMessage({this.text, this.textList, required this.isUser});
}
