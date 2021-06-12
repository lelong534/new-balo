part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesRequested extends MessageEvent {
  final String senderId;
  final String receiverId;

  GetMessagesRequested({required this.senderId, required this.receiverId});

  @override
  List<Object> get props => [senderId, receiverId];
}

class ResetMessages extends MessageEvent {}

class SendMessage extends MessageEvent {
  final UserMainInfo sender;
  final UserMainInfo receiver;
  final String content;

  SendMessage({
    required this.sender,
    required this.receiver,
    required this.content,
  });

  @override
  List<Object> get props => [sender, receiver, content];
}

class RecieveMessage extends MessageEvent {
  final Message message;

  RecieveMessage({required this.message});

  @override
  List<Object> get props => [message];
}
