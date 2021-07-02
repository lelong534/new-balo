import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/authentication/models/user.dart';
import 'package:flutter_zalo_bloc/post/models/comment_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentRepository {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var getListCommentsUrl = '$mainUrl/api/get_comment';
  var addCommentUrl = '$mainUrl/api/add_comment';

  final Dio _dio = Dio();

  Future<CommentResponse> getListComments(int index, int postid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response = await _dio.post(getListCommentsUrl, data: {
        "token": token,
        "id": postid,
        "index": index,
        "count": 20,
      });
      return CommentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CommentResponse.withError("$error");
    }
  }

  Future<CommentResponse> addComment(String content, int postid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "id": postid,
        "content": content,
      });
      await _dio.post(addCommentUrl, data: formData);

      Response response = await _dio.post(getListCommentsUrl, data: {
        "token": token,
        "id": postid,
        "index": 0,
        "count": 20,
      });
      return CommentResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CommentResponse.withError("$error");
    }
  }
}
