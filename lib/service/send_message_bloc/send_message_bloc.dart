import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';
import 'package:surf_practice_chat_flutter/service/messages_bloc/messages_bloc.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatRepository repository;
  final MessagesBloc messagesBloc;

  SendMessageBloc(
    this.repository,
    this.messagesBloc,
  ) : super(SendMessageInitial()) {
    on<SendMessageStart>((event, emit) async {
      emit(SendMessageInProgress());

      try {
        final messages = await repository.sendMessage(event.nickname, event.message);
        emit(SendMessageSuccess(messages));
        messagesBloc.add(MessagesRefreshFromData(messages));
      } on Object catch (e) {
        emit(SendMessageFailure());
        rethrow;
      }
    });
  }
}
