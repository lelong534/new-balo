import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/message/models/models.dart';
import 'package:flutter_zalo_bloc/message/repositories/repositories.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;
  final SocketIoRepository socketIoRepository;
  bool subscribed = false;

  MessageBloc({required this.chatRepository, required this.socketIoRepository})
      : super(MessageState(messages: [], loading: false, receiverId: ''));

  void subscribe({dynamic receiveCallback}) {
    socketIoRepository.subscribeReceiveCallback(callback: receiveCallback);
    subscribed = true;
  }

  getReiceiveCallbacl() {
    return (String jsonData) {
      add(RecieveMessage(message: messageFromJson(jsonData)));
    };
  }

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is GetMessagesRequested) {
      yield MessageState(
        messages: [],
        loading: true,
        receiverId: event.receiverId,
      );

      List<Message> messages = await chatRepository.getMessages(
        senderId: event.senderId,
        receiverId: event.receiverId,
      );
      yield MessageState(
        messages: messages,
        loading: false,
        receiverId: event.receiverId,
      );
    } else if (event is ResetMessages) {
      yield MessageState(messages: [], loading: false, receiverId: '');
    } else if (event is SendMessage) {
      Message message = Message(
        sender: event.sender,
        receiver: event.receiver,
        created: DateTime.now().millisecondsSinceEpoch,
        content: event.content,
        type: 'text',
      );

      chatRepository.sendMessage(message: message);
      socketIoRepository.sendMessage(message: message);

      yield MessageState(
        messages: [...state.messages, message],
        loading: false,
        receiverId: state.receiverId,
      );
    } else if (event is RecieveMessage) {
      if (state.receiverId == event.message.sender.id) {
        yield MessageState(
          messages: [...state.messages, event.message],
          loading: false,
          receiverId: state.receiverId,
        );
      }
    }
  }
}
