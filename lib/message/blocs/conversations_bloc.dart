import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/message/models/models.dart';
import 'package:flutter_zalo_bloc/message/repositories/repositories.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final ChatRepository chatRepository;

  ConversationsBloc({required this.chatRepository})
      : super(ConversationsState(conversations: []));

  @override
  Stream<ConversationsState> mapEventToState(
    ConversationsEvent event,
  ) async* {
    if (event is GetConversations) {
      List<Conversation> conversations =
          await chatRepository.getConversations();

      yield ConversationsState(conversations: conversations);
    } else if (event is ResetConversations) {
      int index = state.conversations
          .indexWhere((element) => element.partner.id == event.receiver.id);

      Conversation conversation = Conversation(
        partner: event.receiver,
        lastTime: DateTime.now().millisecondsSinceEpoch,
        lastContent: event.content,
        lastType: 'text',
      );

      if (index == -1) {
        print('a');
        yield ConversationsState(conversations: [
          conversation,
          ...state.conversations,
        ]);
      } else if (index == state.conversations.length - 1) {
        print('b');
        yield ConversationsState(conversations: [
          conversation,
          ...state.conversations.sublist(0, index),
        ]);
      } else {
        print('c');
        yield ConversationsState(conversations: [
          conversation,
          ...state.conversations.sublist(0, index),
          ...state.conversations.sublist(index + 1),
        ]);
      }
    }
  }
}
