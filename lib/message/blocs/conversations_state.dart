part of 'conversations_bloc.dart';

class ConversationsState extends Equatable {
  final List<Conversation> conversations;

  const ConversationsState({required this.conversations});

  @override
  List<Object> get props => [conversations];
}
