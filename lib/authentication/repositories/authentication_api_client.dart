import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/response_api_client/models/models.dart';
import 'package:http/http.dart' as http;

class AuthenticationApiClient {
  static String mainUrl = "https://bk-zalo.herokuapp.com";
  var signUpUrl = '$mainUrl/api/signup';
  Future<dynamic> signin({
    required String phonenumber,
    required String password,
  }) async {
    Uri url = Uri.https(
      'bk-zalo.herokuapp.com',
      '/api/login',
      {
        'phone_number': phonenumber,
        'password': password,
      },
    );
    http.Response response = await http.post(url);

    if (response.statusCode == 200) {
      ResponseApiClient responseApiClient =
          responseApiClientFromJson(response.body);

      if (responseApiClient.code == 1000) {
        return User(
          userMainInfo: UserMainInfo(
            id: responseApiClient.data!['id'].toString(),
            name: responseApiClient.data!['username'],
            avatar: responseApiClient.data!['avatar'],
          ),
          phonenumber: phonenumber,
          password: password,
          token: responseApiClient.data!['token'],
        );
      } else {
        return responseApiClient.message;
      }
    } else {
      return 'Something went wrong!';
    }
  }

  Future<void> signout({required String token}) async {
    Uri url = Uri.https(
      'bk-zalo.herokuapp.com',
      '/api/logout',
      {
        'token': token,
      },
    );
    await http.post(url);
  }

  Future<dynamic> signup({
    required String name,
    required String phonenumber,
    required String password,
  }) async {
    Uri url = Uri.https(
      'bk-zalo.herokuapp.com',
      '/api/signup',
      {
        'name' : name,
        'phone_number': phonenumber,
        'password': password,
      },
    );
    http.Response response = await http.post(url);

    if (response.statusCode == 200) {
      ResponseApiClient responseApiClient =
          responseApiClientFromJson(response.body);

      return responseApiClient.message;
    } else {
      return 'Something went wrong!';
    }
  }
}
