import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/authentication/models/user.dart';
import 'package:flutter_zalo_bloc/settings/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var loginUrl = '$mainUrl/api/login';
  var signUpUrl = '$mainUrl/api/signup';
  var getUserInfoUrl = '$mainUrl/api/user/get_user_info';
  var changeUserInfoUrl = '$mainUrl/api/change_user_info';
  var getUserByIdUrl = '$mainUrl/api/get_user_by_id';

  final Dio _dio = Dio();

  Future<UserResponse> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response =
          await _dio.post(getUserInfoUrl, data: {"token": token});
      return UserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }

  Future<UserResponse> getUserById(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response = await _dio.post(getUserByIdUrl, data: {
        "token": token,
        "user_id": userId,
      });
      return UserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }

  Future<UserResponse> changeUserAvatar(MultipartFile avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "avatar": avatar,
      });

      await _dio.post(changeUserInfoUrl, data: formData);
      Response response =
          await _dio.post(getUserInfoUrl, data: {"token": token});
      print(response);
      return UserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }

  Future<UserResponse> changeUserCoverImage(MultipartFile coverImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "cover_image": coverImage,
      });

      await _dio.post(changeUserInfoUrl, data: formData);
      Response response =
          await _dio.post(getUserInfoUrl, data: {"token": token});
      print(response);
      return UserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }

  Future<UserResponse> changeUserInfo(
      String name, String description, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      var formData = FormData.fromMap({
        "token": token,
        "username": name,
        "description": description,
        "address": address
      });

      await _dio.post(changeUserInfoUrl, data: formData);
      Response response =
          await _dio.post(getUserInfoUrl, data: {"token": token});
      print(response);
      return UserResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return UserResponse.withError("$error");
    }
  }
}
