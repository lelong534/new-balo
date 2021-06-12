import 'package:flutter_zalo_bloc/post/models/post.dart';

class PostResponse {
  final List<Post> posts;
  final String error;

  PostResponse(this.posts, this.error);

  PostResponse.fromJson(Map<String, dynamic> json)
      : posts = (json["data"]["posts"] as List)
            .map((i) => new Post.fromJson(i))
            .toList(),
        error = "";

  PostResponse.withError(String errorValue)
      : posts = [],
        error = errorValue;
}
