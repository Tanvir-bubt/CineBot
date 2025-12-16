// lib/chatbot_feature/message_bubble.dart
import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'link_options.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    Widget contentWidget;

    if (isUser || message.text != null) {
      contentWidget = Text(
        message.text == "..." ? "AI is typing..." : message.text!,
        style: TextStyle(
          fontSize: 14,
          fontStyle: message.text == "..." ? FontStyle.italic : FontStyle.normal,
        ),
      );
    } else {
      contentWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.textList!.map((item) {
          final tag = item.keys.first;
          final content = item.values.first;

          switch (tag) {
            case 'text':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(content, style: const TextStyle(fontSize: 14)),
              );
            case 'title':
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => LinkOptions.show(context, content),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.indigoAccent,
                        width: 0.6,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      content,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            case 'image':
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Image.network(
                    content,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "can't find image",
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            default:
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(content, style: const TextStyle(fontSize: 14)),
              );
          }
        }).toList(),
      );
    }

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isUser ? 15 : 5),
      topRight: Radius.circular(isUser ? 5 : 15),
      bottomLeft: const Radius.circular(15),
      bottomRight: const Radius.circular(15),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: isUser ? Border.all(color: Colors.black) : null,
          borderRadius: borderRadius,
        ),
        child: contentWidget,
      ),
    );
  }
}
