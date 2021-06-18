class FriendSuggest {
  final int id;
  final String? username;
  final String? avatar;
  final String created;

  FriendSuggest(
    this.id,
    this.username,
    this.avatar,
    this.created,
  );

  FriendSuggest.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"] == null ? "Người dùng" : json["username"],
        avatar = json["avatar"],
        created = json["created"];
}
