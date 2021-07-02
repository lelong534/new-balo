

import 'package:flutter_zalo_bloc/post/models/comment.dart';

class CommentResponse {
  final List<Comment> comments;
  final String error;

  CommentResponse(this.comments, this.error);

  CommentResponse.fromJson(Map<String, dynamic> json)
      : comments = (json["data"]["comment"] as List)
            .map((i) => new Comment.fromJson(i))
            .toList(),
        error = "";

  CommentResponse.withError(String errorValue)
      : comments = [],
        error = errorValue;
}
