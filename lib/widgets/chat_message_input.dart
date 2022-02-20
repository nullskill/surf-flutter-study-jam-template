import 'package:flutter/material.dart';

/// Input for the chat message widget
class ChatMessageInput extends StatelessWidget {
  final Function onPressed;

  ChatMessageInput({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              // TODO: Move to the consts
              hintText: 'Please enter the message',
              // TODO: Move to the theme
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              filled: true,
              fillColor: Colors.white,
              // enabledBorder: outlineInputBorder,
              // disabledBorder: outlineInputBorder,
              // border: outlineInputBorder,
              // errorBorder: outlineInputBorder,
              // focusedBorder: outlineInputBorder,
              // focusedErrorBorder: outlineInputBorder,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onPressed(_controller.text);
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
              Icons.edit,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
