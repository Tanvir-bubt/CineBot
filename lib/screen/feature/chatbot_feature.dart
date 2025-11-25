/*
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
      final aiResponse = await Apis.getAiResponse(userMessage: text);
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
*/

/*
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
      _messages.add(_ChatMessage(text: text, isUser: true, tag: 'text'));
      _controller.clear();

      _typingMessage = _ChatMessage(text: "...", isUser: false, tag: 'text');
      _messages.add(_typingMessage!);
      _isSending = true;
    });

    try {
      final aiResponseList = await Apis.getAiResponse(userMessage: text);

      setState(() {
        _messages.remove(_typingMessage);
        _typingMessage = null;

        // Add all parsed chunks
        for (var item in aiResponseList) {
          final tag = item.keys.first;
          final content = item.values.first;
          _messages.add(_ChatMessage(text: content, tag: tag, isUser: false));
        }
      });
    } catch (e) {
      setState(() {
        _messages.remove(_typingMessage);
        _typingMessage = null;
        _messages.add(_ChatMessage(text: "Error: $e", tag: 'text', isUser: false));
      });
    } finally {
      setState(() => _isSending = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot Feature')),
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
          _buildInputRow(),
        ],
      ),
    );
  }


  Widget _buildInputRow() {
    return Padding(
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
    );
  }
}



class _ChatMessage {
  final String text;
  final bool isUser;
  final String? tag;

  _ChatMessage({required this.text, required this.isUser, this.tag});
}
class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    Widget contentWidget;

    switch (message.tag) {
      case 'image':
        contentWidget = Image.network(
          message.text,
          width: 200, // or whatever max width you want
          fit: BoxFit.fitWidth, // scales to fit width, preserves aspect ratio
        );
        break;

      case 'movie':
        contentWidget = ElevatedButton(
          onPressed: () => _showLinkOptions(context, message.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: Colors.white),
          ),
        );
        break;

      case 'text':
      default:
        contentWidget = Text(
          message.text == "..." ? "AI is typing..." : message.text,
          style: TextStyle(
            fontSize: 16,
            fontStyle: message.text == "..." ? FontStyle.italic : FontStyle.normal,
          ),
        );
        break;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: contentWidget,
      ),
    );
  }


  void _showLinkOptions(BuildContext context, String linkText) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add "$linkText" to:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(context, 'Watch Later'),
            _buildOptionButton(context, 'Watching'),
            _buildOptionButton(context, 'Watched'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop(); // close the bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to "$label"')),
          );
        },
        child: Text(label),
      ),
    );
  }
}
*/


/*class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    Widget contentWidget;

    switch (message.tag) {
      case 'image':
        contentWidget = Image.network(
          message.text,
          width: 200,
          height: 150,
          fit: BoxFit.cover,
        );
        break;

      case 'movie':
        contentWidget = InkWell(
          onTap: () {
            // handle link tap here
          },
          child: Text(
            message.text,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
        break;

      case 'text':
      default:
        contentWidget = Text(
          message.text == "..." ? "AI is typing..." : message.text,
          style: TextStyle(
            fontSize: 16,
            fontStyle: message.text == "..." ? FontStyle.italic : FontStyle.normal,
          ),
        );
        break;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: contentWidget,
      ),
    );
  }
}*/
/*
class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    Widget contentWidget;

    switch (message.tag) {
      case 'image':
        contentWidget = Image.network(
          message.text,
          width: 200, // or whatever max width you want
          fit: BoxFit.fitWidth, // scales to fit width, preserves aspect ratio
        );
        break;

      case 'movie':
        contentWidget = ElevatedButton(
          onPressed: () => _showLinkOptions(context, message.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: Colors.white),
          ),
        );
        break;

      case 'text':
      default:
        contentWidget = Text(
          message.text == "..." ? "AI is typing..." : message.text,
          style: TextStyle(
            fontSize: 16,
            fontStyle: message.text == "..." ? FontStyle.italic : FontStyle.normal,
          ),
        );
        break;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: contentWidget,
      ),
    );
  }


  void _showLinkOptions(BuildContext context, String linkText) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add "$linkText" to:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(context, 'Watch Later'),
            _buildOptionButton(context, 'Watching'),
            _buildOptionButton(context, 'Watched'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop(); // close the bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to "$label"')),
          );
        },
        child: Text(label),
      ),
    );
  }
}
*/


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
      _messages.add(_ChatMessage(text: text, isUser: true, tag: 'text'));
      _controller.clear();

      _typingMessage = _ChatMessage(text: "...", isUser: false, tag: 'text');
      _messages.add(_typingMessage!);
      _isSending = true;
    });

    try {
      final aiResponseList = await Apis.getAiResponse(userMessage: text);

      setState(() {
        _messages.remove(_typingMessage);
        _typingMessage = null;

        for (var item in aiResponseList) {
          final tag = item.keys.first;
          final content = item.values.first;
          _messages.add(_ChatMessage(text: content, tag: tag, isUser: false));
        }
      });
    } catch (e) {
      setState(() {
        _messages.remove(_typingMessage);
        _typingMessage = null;
        _messages.add(_ChatMessage(text: "Error: $e", tag: 'text', isUser: false));
      });
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot Feature')),
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
          _buildInputRow(),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Padding(
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
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final String? tag;

  _ChatMessage({required this.text, required this.isUser, this.tag});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    Widget contentWidget;

    switch (message.tag) {
      case 'image':
      // preserve original aspect ratio
        contentWidget = ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Image.network(
            message.text,
            fit: BoxFit.contain,
          ),
        );
        break;

      case 'movie':
        contentWidget = ElevatedButton(
          onPressed: () => _showLinkOptions(context, message.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: Colors.white),
          ),
        );
        break;

      case 'text':
      default:
        contentWidget = Text(
          message.text == "..." ? "AI is typing..." : message.text,
          style: TextStyle(
            fontSize: 16,
            fontStyle: message.text == "..." ? FontStyle.italic : FontStyle.normal,
          ),
        );
        break;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: contentWidget,
      ),
    );
  }

  void _showLinkOptions(BuildContext context, String movieName) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add "$movieName" to:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(context, 'Watch Later', movieName),
            _buildOptionButton(context, 'Watching', movieName),
            _buildOptionButton(context, 'Watched', movieName),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String label, String movieName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pop();
          try {
            await Apis.add_to_hive(movieName, label); // API call
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added "$movieName" to "$label"')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add: $e')),
            );
          }
        },
        child: Text(label),
      ),
    );
  }
}
