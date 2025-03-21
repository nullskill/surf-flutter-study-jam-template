import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/data/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final ChatRepository repository;

  int _requestNumber = 0;
  int get requestNumber => _requestNumber;

  MessagesBloc(this.repository) : super(MessagesInitial()) {
    on<MessagesRefresh>((event, emit) async {
      emit(MessagesLoadInProgress());
      _requestNumber++;

      try {
        if (_requestNumber == 1) {
          await Future.delayed(const Duration(seconds: 3));
          return emit(MessagesLoadFailure());
        }
        final messages = await repository.messages;
        emit(MessagesLoadSuccess(messages));
      } on Object catch (e) {
        emit(MessagesLoadFailure());
        rethrow;
      }
    });
    on<MessagesRefreshFromData>((event, emit) async {
      emit(MessagesLoadInProgress());
      _requestNumber++;

      try {
        emit(MessagesLoadSuccess(event.data));
      } on Object catch (e) {
        emit(MessagesLoadFailure());
        rethrow;
      }
    });
  }
}
