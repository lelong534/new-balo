// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    required this.id,
    required this.described,
    required this.images,
    required this.video,
    required this.like,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
  });

  String id;
  String described;
  String images;
  String video;
  String like;
  String comment;
  String createdAt;
  String updatedAt;
  String isLiked;
  String authorId;
  String authorName;
  String authorAvatar;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        described: json["described"],
        images: json["images"],
        video: json["video"],
        like: json["like"],
        comment: json["comment"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        isLiked: json["isLiked"],
        authorId: json["authorId"],
        authorName: json["authorName"],
        authorAvatar: json["authorAvatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "described": described,
        "images": images,
        "video": video,
        "like": like,
        "comment": comment,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isLiked": isLiked,
        "authorId": authorId,
        "authorName": authorName,
        "authorAvatar": authorAvatar,
      };
}
