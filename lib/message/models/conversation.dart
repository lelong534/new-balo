// To parse this JSON data, do
//
//     final conversation = conversationFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_zalo_bloc/authentication/models/models.dart';

Conversation conversationFromJson(String str) =>
    Conversation.fromJson(json.decode(str));

String conversationToJson(Conversation data) => json.encode(data.toJson());

class Conversation {
  Conversation({
    required this.partner,
    required this.lastContent,
    required this.lastType,
    required this.lastTime,
  });

  UserMainInfo partner;
  String lastContent;
  String lastType;
  int lastTime;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        partner: UserMainInfo.fromJson(json["partner"]),
        lastContent: json["lastContent"],
        lastType: json["lastType"],
        lastTime: json["lastTime"],
      );

  Map<String, dynamic> toJson() => {
        "partner": partner.toJson(),
        "lastContent": lastContent,
        "lastType": lastType,
        "lastTime": lastTime,
      };
}
