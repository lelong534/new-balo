part of 'message_bloc.dart';

class MessageState extends Equatable {
  final List<Message> messages;
  final bool loading;
  final String receiverId;

  const MessageState({
    required this.messages,
    required this.loading,
    required this.receiverId,
  });

  @override
  List<Object> get props => [messages, loading, receiverId];
}
