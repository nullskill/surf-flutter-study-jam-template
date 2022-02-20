import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/user.dart';

/// A chat message item
class ChatMessageItem extends StatelessWidget {
  final ChatUserDto author;
  final String message;

  const ChatMessageItem({
    Key? key,
    required this.author,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Text(author.name),
      subtitle: Text(message),
    );
  }
}
