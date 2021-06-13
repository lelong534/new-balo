import 'package:flutter_zalo_bloc/message/models/friend.dart';

class FriendResponse {
  final List<Friend> friends;
  final String error;

  FriendResponse(this.friends, this.error);

  FriendResponse.fromJson(Map<String, dynamic> json)
      : friends = (json["data"]["friends"] as List)
            .map((i) => new Friend.fromJson(i))
            .toList(),
        error = "";

  FriendResponse.withError(String errorValue)
      : friends = [],
        error = errorValue;
}
