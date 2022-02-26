import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/res/borders.dart';
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
    final authorName = author.name.characters.first.toUpperCase();
    return Row(
      mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMine)
          CircleAvatar(
            child: Text(
              authorName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                author.name,
                style: TextStyle(
                  fontWeight: isMine ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isMine
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.75)
                    : Theme.of(context).primaryColor.withOpacity(0.75),
                borderRadius: isMine
                    ? const BorderRadius.only(
                        topLeft: circleRadius20,
                        bottomLeft: circleRadius20,
                        bottomRight: circleRadius20,
                      )
                    : const BorderRadius.only(
                        topRight: circleRadius20,
                        bottomLeft: circleRadius20,
                        bottomRight: circleRadius20,
                      ),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
                minHeight: 30,
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        if (isMine)
          CircleAvatar(
            child: Text(
              authorName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
      ],
    );
  }
}
