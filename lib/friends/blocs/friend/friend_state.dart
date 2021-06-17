import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_response.dart';

class FriendState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialFriendState extends FriendState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Initial friend';
}

class ReceivedFriendState extends FriendState {
  final FriendResponse friends;

  ReceivedFriendState(this.friends);

  @override
  List<Object> get props => [friends];

  @override
  String toString() => 'Received Friend';
}

class ErrorFriendState extends FriendState {
  final String errorMessage;

  ErrorFriendState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Error: ' + errorMessage;
}

class LoadingFriendState extends FriendState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Loading';
}

class FriendSearchSuccess extends FriendState {
  final FriendResponse friends;

  @override
  List<Object> get props => [friends];

  FriendSearchSuccess(this.friends);

  @override
  String toString() => 'Friends search success';
}
