import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/assets/strings/strings.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/user.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';
import 'package:surf_practice_chat_flutter/service/messages_bloc/messages_bloc.dart';
import 'package:surf_practice_chat_flutter/service/send_message_bloc/send_message_bloc.dart';
import 'package:surf_practice_chat_flutter/widgets/chat_appbar.dart';
import 'package:surf_practice_chat_flutter/widgets/chat_message_input.dart';
import 'package:surf_practice_chat_flutter/widgets/chat_message_item.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;
  final MessagesBloc messagesBloc;
  final SendMessageBloc sendMessageBloc;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
    required this.messagesBloc,
    required this.sendMessageBloc,
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

  void _onChangeNickname(String nickname) {
    setState(() {
      author = ChatUserDto(name: nickname);
    });
  }

  void _onRefreshMessages() {
    widget.messagesBloc.add(MessagesRefresh());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        onRefreshMessages: _onRefreshMessages,
        onChangeNickname: _onChangeNickname,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessagesBloc, MessagesState>(
                bloc: widget.messagesBloc,
                builder: (context, state) {
                  if (state is MessagesLoadSuccess) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final data = state.messages[index];
                        return ChatMessageItem(author: data.author, message: data.message);
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            ChatMessageInput(
              onPressed: (message) {
                // print('${author.name} wrote: $message');
                widget.sendMessageBloc.add(
                  SendMessageStart(author.name, message),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
