class FriendRequest {
  final int id;
  final String username;
  final String avatar;
  final String created;

  FriendRequest(
    this.id,
    this.username,
    this.avatar,
    this.created,
  );

  FriendRequest.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"] == null ? "Người dùng" : json["username"],
        avatar = json["avatar"],
        created = json["created"];
}
