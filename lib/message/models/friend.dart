class Friend {
  final int id;
  final String username;
  final String avatar;

  Friend(
    this.id,
    this.username,
    this.avatar,
  );

  Friend.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        avatar = json["avatar"];
}
