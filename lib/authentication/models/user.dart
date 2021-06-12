// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_zalo_bloc/authentication/models/user_main_info.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.userMainInfo,
    required this.phonenumber,
    required this.password,
    required this.token,
  });

  UserMainInfo userMainInfo;
  String phonenumber;
  String password;
  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userMainInfo: UserMainInfo(
          id: json["id"],
          name: json["name"],
          avatar: json["avatar"],
        ),
        phonenumber: json["phonenumber"],
        password: json["password"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": userMainInfo.id,
        "name": userMainInfo.name,
        "avatar": userMainInfo.avatar,
        "phonenumber": phonenumber,
        "password": password,
        "token": token,
      };
}
