import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:flutter_zalo_bloc/post/models/post_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostApiClient {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var getListPostsUrl = '$mainUrl/api/get_list_posts';
  var addPostUrl = '$mainUrl/api/add_post';
  var likePostUrl = '$mainUrl/api/like';
  var unLikePostUrl = '$mainUrl/api/un_like';
  var deletePostUrl = '$mainUrl/api/delete_post';

  final Dio _dio = Dio();

  Future<PostResponse> getListPosts(int index, int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      Response response = await _dio.post(getListPostsUrl, data: {
        "token": token,
        "index": index,
        "count": count,
      });
      return PostResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PostResponse.withError("$error");
    }
  }

  Future<PostResponse> getListPostsByUser(
      int index, int count, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      Response response = await _dio.post(getListPostsUrl, data: {
        "token": token,
        "index": index,
        "count": count,
        "user_id": userId
      });
      return PostResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PostResponse.withError("$error");
    }
  }

  Future<PostResponse> addPost(
      List<MultipartFile>? images, File? video, String described) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      var formData = FormData.fromMap({
        "token": token,
        "image[]": images,
        "video" : await MultipartFile.fromFile(video!.path),
        "described": described,
      });
      print("========================");
      Response res = await _dio.post(addPostUrl, data: formData);
      print(res);
      print("========================");
      Response response = await _dio.post(getListPostsUrl, data: {
        "token": token,
        "index": 0,
        "count": 20,
      });
      return PostResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PostResponse.withError("$error");
    }
  }

  Future<PostResponse> likePost(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      await _dio.post(likePostUrl, data: {
        "token": token,
        "id": post.id,
      });

      Response response = await _dio.post(getListPostsUrl, data: {
        "token": token,
        "index": 0,
        "count": 20,
      });
      return PostResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PostResponse.withError("$error");
    }
  }

  Future<PostResponse> unLikePost(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }

    try {
      await _dio.post(unLikePostUrl, data: {
        "token": token,
        "id": post.id,
      });

      Response response = await _dio.post(getListPostsUrl, data: {
        "token": token,
        "index": 0,
        "count": 20,
      });
      return PostResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PostResponse.withError("$error");
    }
  }

  Future<void> deletePost(int postid) async {}
}
