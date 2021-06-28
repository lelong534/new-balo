import 'user.dart';

class UserResponse {
  final User user;
  final String? error;

  UserResponse(this.user, this.error);

  UserResponse.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json),
        error = "";

  UserResponse.withError(String errorValue)
      : user = User.fromJson({
          "id": null,
          "phonenumber": null,
          "birthday": null,
          "description": null,
          "address": null,
        }),
        error = errorValue;
}
