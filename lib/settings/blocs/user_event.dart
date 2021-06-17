import 'package:dio/dio.dart';
import 'package:flutter_zalo_bloc/settings/models/user_response.dart';

abstract class UserEvent {}

class LoadingUserEvent extends UserEvent {}

class UserChangeAvatarEvent extends UserEvent {
  final MultipartFile avatar;
  final UserResponse user;

  UserChangeAvatarEvent(this.avatar, this.user);

  @override
  String toString() => 'Change avatar';
}

class UserChangeCoverImageEvent extends UserEvent {
  final MultipartFile coverImage;

  UserChangeCoverImageEvent(this.coverImage);

  @override
  String toString() => 'Change coverImage';
}

class LoadUserProfile extends UserEvent {
  final int userId;

  LoadUserProfile({required this.userId});

  @override
  String toString() => 'Show user profile';
}

class UserChangeInfoEvent extends UserEvent {
  final String name;
  final String description;
  final String address;

  UserChangeInfoEvent(this.name, this.description, this.address);

  @override
  String toString() => 'Change info';
}
