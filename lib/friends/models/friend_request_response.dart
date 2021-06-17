import 'friend_request.dart';

class FriendRequestResponse {
  final List<FriendRequest> friendRequests;
  final String error;

  FriendRequestResponse(this.friendRequests, this.error);

  FriendRequestResponse.fromJson(Map<String, dynamic> json)
      : friendRequests = (json["data"]["requested"] as List)
            .map((i) => new FriendRequest.fromJson(i))
            .toList(),
        error = "";

  FriendRequestResponse.withError(String errorValue)
      : friendRequests = [],
        error = errorValue;
}
