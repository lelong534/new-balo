// To parse this JSON data, do
//
//     final userMainInfo = userMainInfoFromJson(jsonString);

import 'dart:convert';

UserMainInfo userMainInfoFromJson(String str) =>
    UserMainInfo.fromJson(json.decode(str));

String userMainInfoToJson(UserMainInfo data) => json.encode(data.toJson());

class UserMainInfo {
  UserMainInfo({
    required this.id,
    required this.name,
    this.avatar,
  });

  String id;
  String name;
  String? avatar;

  factory UserMainInfo.fromJson(Map<String, dynamic> json) => UserMainInfo(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
      };
}
