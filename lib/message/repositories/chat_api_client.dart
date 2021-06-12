import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/message/helpers/helpers.dart';
import 'package:flutter_zalo_bloc/message/models/models.dart';

class ChatApiClient {
  Future<List<Message>> getMessages({
    required String senderId,
    required String receiverId,
  }) async {
    String conversationId = getConversationId(
      senderId: senderId,
      receiverId: receiverId,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('created')
        .get();

    List<Message> result = [];
    querySnapshot.docs.forEach((DocumentSnapshot element) {
      result.add(Message(
        sender: UserMainInfo.fromJson(element.data()!['sender']),
        receiver: UserMainInfo.fromJson(element.data()!['receiver']),
        created: element.data()!['created'],
        content: element.data()!['content'],
        type: element.data()!['type'],
      ));
    });

    return result;
  }

  Future<void> sendMessage({required Message message}) async {
    String conversationId = getConversationId(
      senderId: message.sender.id,
      receiverId: message.receiver.id,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'sender': message.sender.toJson(),
      'receiver': message.receiver.toJson(),
      'created': message.created,
      'content': message.content,
      'type': message.type,
    });
  }
}
