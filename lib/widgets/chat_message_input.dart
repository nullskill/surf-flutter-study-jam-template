import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/res/borders.dart';
import 'package:surf_practice_chat_flutter/assets/strings/strings.dart';

/// Input for the chat message widget
class ChatMessageInput extends StatefulWidget {
  final Function onPressed;

  const ChatMessageInput({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: chatRoomMessageInputHint,
                // TODO: Move to the theme
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                filled: true,
                enabledBorder: outlineInputBorder,
                disabledBorder: outlineInputBorder,
                border: outlineInputBorder,
                errorBorder: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                focusedErrorBorder: outlineInputBorder,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onPressed(_controller.text);
              _controller.clear();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xffffae88), Color(0xff8f93ea)],
                ),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
