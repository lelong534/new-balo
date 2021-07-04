import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

        yield Authenticated(user: signinResult);
      } else {
        yield AuthenticationRequestFailure(message: signinResult);
      }
    } else if (event is SignUp) {
      yield SignUpStartingRequest();
      final signUpResult = await authenticationRepository.signup(
        name: event.name,
        phonenumber: event.phonenumber,
        password: event.password,
      );
      if (signUpResult != null) {
        yield SignUpLoadingRequeset(message: signUpResult);
      }
    } else if (event is SignOut) {
      if (state is Authenticated) {
        socketIoRepository.disconnect();

        User user = state.props[0] as User;
        yield UnauthenticationRequestLoading(user: user);

        await authenticationRepository.removePersistenceUser();
        await authenticationRepository.signout(token: user.token);

        yield Unauthenticated();
      }
    }
  }
}
