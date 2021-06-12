import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPersist {
  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('user');
    if (json != null) {
      return userFromJson(json);
    } else {
      return null;
    }
  }

  Future<void> setUser({required User user}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', userToJson(user));
  }

  Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
