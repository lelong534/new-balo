import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/authentication/models/user.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_request_response.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_response.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_suggest_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendRepository {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var getListFriendsUrl = '$mainUrl/api/user/get_user_friends';
  var getListFriendRequestUrl = '$mainUrl/api/user/get_requested_friends';
  var setAcceptFriend = '$mainUrl/api/user/set_accept_friend';
  var getListFriendSuggestUrl = "$mainUrl/api/user/get_suggested_friends";
  var setRequestFriendUrl = "$mainUrl/api/user/set_request_friends";

  final Dio _dio = Dio();

  Future<FriendResponse> getListFriends(int index, int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response = await _dio.post(getListFriendsUrl, data: {
        "token": token,
        "index": index,
        "count": count,
      });
      print(response);
      return FriendResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return FriendResponse.withError("$error");
    }
  }

  Future<FriendRequestResponse> getListFriendRequest(
      int index, int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response = await _dio.post(getListFriendRequestUrl, data: {
        "token": token,
        "index": index,
        "count": count,
      });
      return FriendRequestResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return FriendRequestResponse.withError("$error");
    }
  }

  Future<FriendSuggestResponse> getListSuggestRequest(
      int index, int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response = await _dio.post(getListFriendSuggestUrl, data: {
        "token": token,
        "index": index,
        "count": count,
      });
      return FriendSuggestResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return FriendSuggestResponse.withError("$error");
    }
  }

  Future<FriendRequestResponse> acceptFriend(int userid, int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "user_id": userid,
        "is_accepted": status,
      });
      Response res = await _dio.post(setAcceptFriend, data: formData);
      print(res);
      Response response = await _dio.post(getListFriendRequestUrl, data: {
        "token": token,
        "index": 0,
        "count": 10,
      });
      return FriendRequestResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return FriendRequestResponse.withError("$error");
    }
  }

  Future<FriendRequestResponse> rejectFriend(int userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "user_id": userid,
        "is_accepted": 0,
      });
      await _dio.post(setAcceptFriend, data: formData);

      Response response = await _dio.post(getListFriendRequestUrl, data: {
        "token": token,
        "index": 0,
        "count": 10,
      });
      return FriendRequestResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return FriendRequestResponse.withError("$error");
    }
  }

  Future<FriendSuggestResponse> requestFriend(int userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "user_id": userid,
      });
      await _dio.post(setRequestFriendUrl, data: formData);
      Response response = await _dio.post(getListFriendSuggestUrl, data: {
        "token": token,
        "index": 0,
        "count": 10,
      });
      return FriendSuggestResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return FriendSuggestResponse.withError("$error");
    }
  }
}
