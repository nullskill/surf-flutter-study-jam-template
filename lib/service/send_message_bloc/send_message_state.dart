part of 'send_message_bloc.dart';

abstract class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

class SendMessageInitial extends SendMessageState {}

class SendMessageInProgress extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  final List<ChatMessageDto> messages;

  const SendMessageSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class SendMessageFailure extends SendMessageState {}
