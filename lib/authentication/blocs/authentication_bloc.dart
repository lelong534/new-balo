import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/authentication/repositories/repositories.dart';
import 'package:flutter_zalo_bloc/message/repositories/repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final SocketIoRepository socketIoRepository;

  AuthenticationBloc({
    required this.authenticationRepository,
    required this.socketIoRepository,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is Initialize) {
      User? user = await authenticationRepository.getPersistenceUser();

      if (user != null) {
        socketIoRepository.connect(userId: user.userMainInfo.id);

        yield Authenticated(user: user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignIn) {
      yield AuthenticationRequestLoading();

      final signinResult = await authenticationRepository.signin(
        phonenumber: event.phonenumber,
        password: event.password,
      );

      if (signinResult is User) {
        socketIoRepository.connect(userId: signinResult.userMainInfo.id);

        await authenticationRepository.setPersistenceUser(user: signinResult);
        await subscribePushNotification(userId: signinResult.userMainInfo.id);

        yield Authenticated(user: signinResult);
      } else {
        yield AuthenticationRequestFailure(message: signinResult);
      }
    } else if (event is SignOut) {
      if (state is Authenticated) {
        socketIoRepository.disconnect();

        User user = state.props[0] as User;
        yield UnauthenticationRequestLoading(user: user);

        await authenticationRepository.removePersistenceUser();
        await unsubscribePushNotification(userId: user.userMainInfo.id);
        await authenticationRepository.signout(token: user.token);

        yield Unauthenticated();
      }
    }
  }

  subscribePushNotification({required String userId}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String? token = await messaging.getToken();

    await firestore.collection('pushtokens').doc(userId).set({
      'token': token,
    });
  }

  unsubscribePushNotification({required String userId}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await messaging.deleteToken();

    await firestore.collection('pushtokens').doc(userId).set({
      'token': null,
    });
  }
}
