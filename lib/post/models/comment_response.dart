import 'package:flutter_zalo_bloc/post/models/comment.dart';

class CommentResponse {
  final List<Comment> comments;
  final int countLike;
  final int countComment;
  final String error;

  CommentResponse(this.comments, this.countLike, this.countComment, this.error);

  CommentResponse.fromJson(Map<String, dynamic> json)
      : comments = (json["data"]["comment"] as List)
            .map((i) => new Comment.fromJson(i))
            .toList(),
        countLike = json["data"]["post"]["like"],
        countComment = json["data"]["post"]["comment"],
        error = "";

  CommentResponse.withError(String errorValue)
      : comments = [],
        countLike = 0,
        countComment = 0,
        error = errorValue;
}
