class Search {
  final int id;
  final String username;
  final String avatar;

  Search(
    this.id,
    this.username,
    this.avatar,
  );

  Search.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"] == null ? "Người dùng" : json["username"],
        avatar = json["avatar"] == null ? "avatar" : json["avatar"];
}
