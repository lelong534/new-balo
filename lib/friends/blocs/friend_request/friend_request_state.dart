import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_request_response.dart';

class FriendRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialFriendRequestState extends FriendRequestState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Initial friend';
}

class ReceivedFriendRequestState extends FriendRequestState {
  final FriendRequestResponse friends;

  ReceivedFriendRequestState(this.friends);

  @override
  List<Object> get props => [friends];

  @override
  String toString() => 'Received Friend';
}

class ErrorFriendRequestState extends FriendRequestState {
  final String errorMessage;

  ErrorFriendRequestState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Error: ' + errorMessage;
}

class LoadingFriendRequestState extends FriendRequestState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Loading';
}
