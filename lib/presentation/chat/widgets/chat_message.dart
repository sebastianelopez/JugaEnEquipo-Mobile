import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.type,
    required this.text,
  });

  final String type;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (type == "receiver" ? Colors.grey.shade200 : Colors.red[200]),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: Colors.grey.shade900),
      ),
    );
  }
}
