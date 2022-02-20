part of 'send_message_bloc.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageStart extends SendMessageEvent {
  final String nickname;
  final String message;

  const SendMessageStart(this.nickname, this.message);

  @override
  List<Object> get props => [nickname, message];
}
