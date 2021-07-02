class Comment {
  final int id;
  final String content;
  final String authorName;
  final String authorAvatar;

  Comment(
    this.id,
    this.content,
    this.authorName,
    this.authorAvatar,
  );

  Comment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        content = json["content"],
        authorName = json["author"]["name"],
        authorAvatar = json["author"]["avatar"];
}
