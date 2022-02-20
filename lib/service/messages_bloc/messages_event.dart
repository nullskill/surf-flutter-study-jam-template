part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class MessagesRefresh extends MessagesEvent {}

class MessagesRefreshFromData extends MessagesEvent {
  final List<ChatMessageDto> data;

  const MessagesRefreshFromData(this.data);

  @override
  List<Object> get props => [data];
}
