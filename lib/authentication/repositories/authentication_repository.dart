import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/authentication/repositories/repositories.dart';

class AuthenticationRepository {
  final AuthenticationApiClient authenticationApiClient;

  final AuthenticationPersist authenticationPersist;

  AuthenticationRepository({
    required this.authenticationApiClient,
    required this.authenticationPersist,
  });

  Future<User?> getPersistenceUser() async {
    return authenticationPersist.getUser();
  }

  Future<void> setPersistenceUser({required User user}) async {
    await authenticationPersist.setUser(user: user);
  }

  Future<void> removePersistenceUser() async {
    await authenticationPersist.removeUser();
  }

  Future<dynamic> signin({
    required String phonenumber,
    required String password,
  }) async {
    return authenticationApiClient.signin(
      phonenumber: phonenumber,
      password: password,
    );
  }

  Future<dynamic> signup({
    required String name,
    required String phonenumber,
    required String password,
  }) async {
    return authenticationApiClient.signup(
      name: name,
      phonenumber: phonenumber,
      password: password,
    );
  }

  Future<void> signout({required String token}) async {
    await authenticationApiClient.signout(token: token);
  }
}
