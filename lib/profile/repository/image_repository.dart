import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/authentication/models/user.dart';
import 'package:flutter_zalo_bloc/profile/models/image_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageRepository {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var getListImageUrl = '$mainUrl/api/get_list_images';

  final Dio _dio = Dio();

  Future<ImageResponse> getListImages(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";

    String? json = prefs.getString('user');
    if (json != null) {
      token = userFromJson(json).token;
    }
    try {
      Response response = await _dio.post(getListImageUrl, data: {
        "token": token,
        "user_id": userId,
      });
      print(response);
      return ImageResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ImageResponse.withError("$error");
    }
  }
}
