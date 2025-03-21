import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/colors/colors.dart';
import 'package:surf_practice_chat_flutter/assets/res/borders.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/user.dart';

/// A chat message item
class ChatMessageItem extends StatelessWidget {
  final ChatUserDto author;
  final String message;
  final Color color;
  final bool isMine;

  const ChatMessageItem({
    Key? key,
    required this.author,
    required this.message,
    required this.color,
    this.isMine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authorName = author.name.characters.first.toUpperCase();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
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
              backgroundColor: color,
            ),
          Column(
            crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  author.name,
                  style: TextStyle(
                    color: color,
                    fontWeight: isMine ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.fromLTRB(6, 2, 6, 0),
                decoration: BoxDecoration(
                  color: isMine ? AppColors.selfBubble : AppColors.bubble,
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
                    color: isMine ? Theme.of(context).colorScheme.onPrimary : null,
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
              backgroundColor: color,
            ),
        ],
      ),
    );
  }
}
