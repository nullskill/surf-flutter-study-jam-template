part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoadInProgress extends MessagesState {}

class MessagesLoadSuccess extends MessagesState {
  final List<ChatMessageDto> messages;
  const MessagesLoadSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesLoadFailure extends MessagesState {}
