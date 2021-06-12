import 'package:flutter_zalo_bloc/message/models/models.dart';
import 'package:flutter_zalo_bloc/message/repositories/repositories.dart';

class ChatRepository {
  final ChatApiClient chatApiClient;

  ChatRepository({required this.chatApiClient});

  Future<List<Message>> getMessages({
    required String senderId,
    required String receiverId,
  }) async {
    return chatApiClient.getMessages(
      senderId: senderId,
      receiverId: receiverId,
    );
  }

  Future<void> sendMessage({required Message message}) async {
    chatApiClient.sendMessage(message: message);
  }
}
