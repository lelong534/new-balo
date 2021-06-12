// To parse this JSON data, do
//
//     final myResponse = myResponseFromJson(jsonString);

import 'dart:convert';

ResponseApiClient responseApiClientFromJson(String str) =>
    ResponseApiClient.fromJson(json.decode(str));

String responseApiClientToJson(ResponseApiClient data) =>
    json.encode(data.toJson());

class ResponseApiClient {
  ResponseApiClient({
    required this.code,
    required this.message,
    this.data,
  });

  int code;
  String message;
  Map<String, dynamic>? data;

  factory ResponseApiClient.fromJson(Map<String, dynamic> json) =>
      ResponseApiClient(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}
