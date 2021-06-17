import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/settings/models/user_response.dart';

class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserChanging extends UserState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'User changing';
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'User loading';
}

class UserUpdated extends UserState {
  final UserResponse user;

  @override
  List<Object> get props => [user];

  UserUpdated({required this.user});

  @override
  String toString() => 'User updated';
}

class UserDetailLoadSuccess extends UserState {
  final UserResponse user;

  @override
  List<Object> get props => [user];

  UserDetailLoadSuccess(this.user);

  @override
  String toString() => 'User detail load success';
}

class UserFailure extends UserState {
  final String error;

  UserFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'UserFailure { error: $error }';
}
