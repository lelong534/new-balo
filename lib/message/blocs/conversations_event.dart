part of 'conversations_bloc.dart';

abstract class ConversationsEvent extends Equatable {
  const ConversationsEvent();

  @override
  List<Object> get props => [];
}

class GetConversations extends ConversationsEvent {}

class ResetConversations extends ConversationsEvent {
  final UserMainInfo receiver;
  final String content;

  ResetConversations({required this.receiver, required this.content});

  @override
  List<Object> get props => [receiver, content];
}
