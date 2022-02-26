import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/assets/colors/colors.dart';
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
    _isScrollAtEnd.dispose();
    _author.dispose();

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
      backgroundColor: AppColors.background,
      appBar: ChatAppBar(
        onRefreshMessages: _onRefreshMessages,
        onChangeNickname: _onChangeNickname,
      ),
      body: _Body(
        widget: widget,
        scrollController: _scrollController,
        author: _author,
      ),
      floatingActionButtonLocation: _EndFloatFabLocation(),
      floatingActionButton: _Fab(
        isScrollAtEnd: _isScrollAtEnd,
        onFabTap: _onFabTap,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required this.widget,
    required ScrollController scrollController,
    required ValueNotifier<ChatUserDto> author,
  })  : _scrollController = scrollController,
        _author = author,
        super(key: key);

  final ChatScreen widget;
  final ScrollController _scrollController;
  final ValueNotifier<ChatUserDto> _author;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}

class _Fab extends StatelessWidget {
  final ValueNotifier<bool> isScrollAtEnd;
  final VoidCallback onFabTap;
  const _Fab({
    Key? key,
    required this.isScrollAtEnd,
    required this.onFabTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: isScrollAtEnd,
      builder: (context, child) {
        if (isScrollAtEnd.value) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: onFabTap,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 32,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom offset for [floatingActionButtonLocation] in [Scaffold]
class _EndFloatFabLocation extends StandardFabLocation with FabEndOffsetX, FabFloatOffsetY {
  @override
  double getOffsetX(ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    final double directionalAdjustment = scaffoldGeometry.textDirection == TextDirection.ltr ? -8 : 8;
    return super.getOffsetX(scaffoldGeometry, adjustment) - directionalAdjustment;
  }
}
