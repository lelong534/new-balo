import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/search/models/search_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchApiClient {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var getListFriendsUrl = '$mainUrl/api/user/get_user_friends';
  var addCommentUrl = '$mainUrl/api/add_comment';
  var getListFriendRequestUrl = '$mainUrl/api/user/get_requested_friends';
  var setAcceptFriend = '$mainUrl/api/user/set_accept_friend';
  var getListFriendSuggestUrl = "$mainUrl/api/user/get_suggested_friends";
  var setRequestFriendUrl = "$mainUrl/api/user/set_request_friends";
  var searchUrl = "$mainUrl/api/search";

  final Dio _dio = Dio();

  Future<SearchResponse> search(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      Response response = await _dio.post(searchUrl,
          data: {"token": token, "keyword": keyword, "index": 0, "count": 20});
      return SearchResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SearchResponse.withError("$error");
    }
  }
}
