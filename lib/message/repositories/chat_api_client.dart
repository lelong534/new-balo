import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/message/helpers/helpers.dart';
import 'package:flutter_zalo_bloc/message/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    await firestore.collection('conversations').doc(conversationId).set({
      'ids': [message.sender.id, message.receiver.id],
      'lastTime': message.created,
      'lastMessage': {
        'sender': message.sender.toJson(),
        'receiver': message.receiver.toJson(),
        'content': message.content,
        'type': message.type,
      },
    });

    DocumentSnapshot documentSnapshot =
        await firestore.collection('pushtokens').doc(message.receiver.id).get();
    String? token = documentSnapshot.data()!['token'];
    if (token != null) {
      Uri url = Uri.https('fcm.googleapis.com', '/fcm/send');
      http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAACQpsJTw:APA91bHq3SS8Eudfd8pInV8-39xIXZXAKcTF5mG_R8kN3LeHFyNtV7-zzFrSIfh_zxt0c12D_sp2SdtUJFwLtqORW2ETVN8DvG_H_nd_nyZGBOzrUMy1AqYctJgIFprkZKSW0I37fy5h',
        },
        body: jsonEncode(
          {
            'notification': {
              'title': message.sender.name,
              'body': message.content,
            },
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'sound': 'default',
            },
            'to': token,
          },
        ),
      );
    }
  }

  Future<List<Conversation>> getConversations() async {
    User? user = await getUser();
    if (user is User) {
      String userId = user.userMainInfo.id;

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await firestore
          .collection('conversations')
          .where('ids', arrayContains: userId)
          .orderBy('lastTime', descending: true)
          .get();

      List<Conversation> result = [];
      querySnapshot.docs.forEach((DocumentSnapshot element) {
        UserMainInfo user1 =
            UserMainInfo.fromJson(element.data()!['lastMessage']['sender']);

        UserMainInfo user2 =
            UserMainInfo.fromJson(element.data()!['lastMessage']['receiver']);

        result.add(Conversation(
          partner: userId == user1.id ? user2 : user1,
          lastTime: element.data()!['lastTime'],
          lastContent: element.data()!['lastMessage']['content'],
          lastType: element.data()!['lastMessage']['type'],
        ));
      });

      return result;
    }

    return [];
  }

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('user');
    if (json != null) {
      return userFromJson(json);
    } else {
      return null;
    }
  }
}
