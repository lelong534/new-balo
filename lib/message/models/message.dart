// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_zalo_bloc/authentication/models/models.dart';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.sender,
    required this.receiver,
    required this.created,
    required this.content,
    required this.type,
  });

  UserMainInfo sender;
  UserMainInfo receiver;
  int created;
  String content;
  String type;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: UserMainInfo.fromJson(json["sender"]),
        receiver: UserMainInfo.fromJson(json["receiver"]),
        created: json["created"],
        content: json["content"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender.toJson(),
        "receiver": receiver.toJson(),
        "created": created,
        "content": content,
        "type": type,
      };
}
