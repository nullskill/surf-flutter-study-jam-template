import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/user.dart';

/// A chat message item
class ChatMessageItem extends StatelessWidget {
  final ChatUserDto author;
  final String message;
  final bool isMine;

  const ChatMessageItem({
    Key? key,
    required this.author,
    required this.message,
    this.isMine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isMine ? Theme.of(context).primaryColor.withOpacity(0.15) : null,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            author.name.characters.first,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        title: Text(
          author.name,
          style: TextStyle(
            fontWeight: isMine ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(message),
      ),
    );
  }
}
