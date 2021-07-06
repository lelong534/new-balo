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
    this.video,
    required this.like,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
    required this.isHide,
    required this.isBlock,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
  });

  int id;
  String described;
  List images;
  List? video;
  int like;
  int comment;
  String createdAt;
  String updatedAt;
  bool isLiked;
  bool isHide;
  bool isBlock;
  int authorId;
  String authorName;
  String authorAvatar;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        described: json["described"],
        images: json["images"],
        video: json["videos"],
        like: json["like"],
        comment: json["comment"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isLiked: json["isLiked"],
        isHide: json["isHide"] == null ? false : json["isHide"],
        isBlock: json["isBlock"] == null ? false : json["isBlock"],
        authorId: json["author"]["id"],
        authorName: json["author"]["name"] == null
            ? "Người dùng"
            : json["author"]["name"],
        authorAvatar: json["author"]["avatar"] == null
            ? "avatar"
            : json["author"]["avatar"],
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
        "isHide": isHide,
        "isBlock": isBlock,
        "authorId": authorId,
        "authorName": authorName,
        "authorAvatar": authorAvatar,
      };
}
