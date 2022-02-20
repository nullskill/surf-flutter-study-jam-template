import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/assets/strings/strings.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/user.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';
import 'package:surf_practice_chat_flutter/widgets/chat_appbar.dart';
import 'package:surf_practice_chat_flutter/widgets/chat_message_input.dart';
import 'package:surf_practice_chat_flutter/widgets/chat_message_item.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatUserDto author;

  @override
  void initState() {
    super.initState();

    author = const ChatUserDto(name: chatRoomDefaultUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ChatMessageItem(author: author, message: 'some message');
                },
              ),
            ),
            ChatMessageInput(
              onPressed: (message) {
                // TODO: Refactor
                print('new message: $message');
                // BlocProvider.of<ChatRoomBloc>(context).add(
                //   SendMessage(
                //     chatMessage: ChatMessage(
                //       author: user,
                //       message: message,
                //       time:
                //           DateTime.now().millisecondsSinceEpoch.toString(),
                //     ),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
