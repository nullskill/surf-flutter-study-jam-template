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
  final _author = ValueNotifier<ChatUserDto>(const ChatUserDto(name: chatRoomDefaultUsername));

  final _scrollController = ScrollController();
  final _scrollPosition = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _scrollPosition.value = _scrollController.position.atEdge && _scrollController.position.pixels == 0 ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollPosition.dispose();
    _author.dispose();

    super.dispose();
  }

  void _onChangeNickname(String nickname) {
    _author.value = ChatUserDto(name: nickname.isEmpty ? chatRoomDefaultUsername : nickname);
  }

  void _onRefreshMessages() {
    _scrollPosition.value = 0;
    widget.messagesBloc.add(MessagesRefresh());
  }

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
        scrollPosition: _scrollPosition,
        onFabTap: _onFabTap,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ChatScreen widget;
  final ScrollController _scrollController;
  final ValueNotifier<ChatUserDto> _author;

  const _Body({
    Key? key,
    required this.widget,
    required ScrollController scrollController,
    required ValueNotifier<ChatUserDto> author,
  })  : _scrollController = scrollController,
        _author = author,
        super(key: key);

  static const colors = <MaterialColor>[
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessagesBloc, MessagesState>(
              bloc: widget.messagesBloc,
              builder: (context, state) {
                if (state is MessagesLoadInProgress && widget.messagesBloc.requestNumber == 1) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MessagesLoadSuccess) {
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final data = state.messages[index];
                      final colorIndex = data.author.name.hashCode % colors.length;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ChatMessageItem(
                          author: data.author,
                          message: data.message,
                          color: colors[colorIndex],
                          isMine: data.author.name == _author.value.name,
                        ),
                      );
                    },
                  );
                } else if (state is MessagesLoadFailure) {
                  return const Center(
                    child: Text(chatRoomFailure),
                  );
                } else {
                  return const SizedBox.shrink();
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
  final ValueNotifier<double> scrollPosition;
  final VoidCallback onFabTap;
  const _Fab({
    Key? key,
    required this.scrollPosition,
    required this.onFabTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: scrollPosition,
      child: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          onPressed: onFabTap,
          backgroundColor: AppColors.gradientEnd,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 32,
          ),
        ),
      ),
      builder: (context, double value, child) {
        return AnimatedScale(
          scale: value,
          alignment: Alignment.center,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 250),
          child: child,
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

  @override
  double getOffsetY(ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    return super.getOffsetY(scaffoldGeometry, adjustment) - 70;
  }
}
