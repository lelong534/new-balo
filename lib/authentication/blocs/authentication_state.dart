part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;

  Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthenticationState {}

class AuthenticationRequestLoading extends Unauthenticated {}

class AuthenticationRequestFailure extends Unauthenticated {
  final String message;

  AuthenticationRequestFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class UnauthenticationRequestLoading extends Authenticated {
  UnauthenticationRequestLoading({required User user}) : super(user: user);
}
