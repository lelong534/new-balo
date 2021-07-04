class User {
  final int id;
  final String name;
  final String phonenumber;
  final String avatar;
  final String coverImage;
  final String description;
  final String address;

  User(
      {required this.id,
      this.name = "Người dùng",
      required this.phonenumber,
      required this.avatar,
      required this.coverImage,
      required this.description,
      required this.address});

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        phonenumber = json["phone_number"],
        avatar = json["avatar"] == null ? "avatar" : json["avatar"],
        coverImage =
            json["cover_image"] == null ? "avatar" : json["cover_image"],
        description = json["description"] == null ? " " : json["description"],
        address = json["address"] == null ? " " : json["address"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
      };
}
