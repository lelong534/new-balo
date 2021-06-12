part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class Initialize extends AuthenticationEvent {}

class SignUp extends AuthenticationEvent {
  final String name;
  final String phonenumber;
  final String password;

  SignUp({
    required this.name,
    required this.phonenumber,
    required this.password,
  });

  @override
  List<Object> get props => [name, phonenumber, password];
}

class SignIn extends AuthenticationEvent {
  final String phonenumber;
  final String password;

  SignIn({required this.phonenumber, required this.password});

  @override
  List<Object> get props => [phonenumber, password];
}

class SignOut extends AuthenticationEvent {}
