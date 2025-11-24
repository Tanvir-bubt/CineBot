import 'package:flutter/material.dart';
import 'package:cinebot/apis/apis.dart';

class ChatbotFeature extends StatefulWidget {
  const ChatbotFeature({super.key});

  @override
  State<ChatbotFeature> createState() => _ChatbotFeatureState();
}

class _ChatbotFeatureState extends State<ChatbotFeature> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _isSending = false;
  _ChatMessage? _typingMessage;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      // add user's message
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();

      // add typing indicator
      _typingMessage = _ChatMessage(text: "...", isUser: false);
      _messages.add(_typingMessage!);
      _isSending = true;
    });

    try {
      final aiResponse = await getAIResponse(userMessage: text);
      setState(() {
        // remove typing indicator
        _messages.remove(_typingMessage);
        _typingMessage = null;

        // add AI response
        _messages.add(_ChatMessage(text: aiResponse, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.remove(_typingMessage);
        _typingMessage = null;

        _messages.add(
          _ChatMessage(text: "Error: $e", isUser: false),
        );
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Feature'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _MessageBubble(message: msg);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send, size: 18),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text == "..." ? "AI is typing..." : message.text,
          style: TextStyle(
            fontSize: 16,
            fontStyle: message.text == "..." ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
