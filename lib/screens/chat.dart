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

/// Chat screen
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
  final ValueNotifier<ChatUserDto> _author = ValueNotifier(const ChatUserDto(name: chatRoomDefaultUsername));

  final _scrollController = ScrollController();
  final ValueNotifier<bool> _isScrollAtEnd = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() => _isScrollAtEnd.value = _scrollController.position.atEdge);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onChangeNickname(String nickname) => _author.value = ChatUserDto(name: nickname);

  void _onRefreshMessages() => widget.messagesBloc.add(MessagesRefresh());

  void _onFabTap() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(
        onRefreshMessages: _onRefreshMessages,
        onChangeNickname: _onChangeNickname,
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _isScrollAtEnd,
        builder: (context, child) {
          if (_isScrollAtEnd.value) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                // backgroundColor: AppColor.onPrimary,
                onPressed: _onFabTap,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 32,
                ),
                // backgroundColor: Colors.black,
              ),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessagesBloc, MessagesState>(
                bloc: widget.messagesBloc,
                builder: (context, state) {
                  if (state is MessagesLoadSuccess) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final data = state.messages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ChatMessageItem(
                              author: data.author,
                              message: data.message,
                              isMine: data.author.name == _author.value.name,
                            ),
                          );
                        },
                      ),
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
                widget.sendMessageBloc.add(
                  SendMessageStart(_author.value.name, message),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
