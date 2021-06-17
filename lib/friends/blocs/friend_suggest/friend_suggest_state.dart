import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_suggest_response.dart';

class FriendSuggestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialFriendSuggestState extends FriendSuggestState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Initial friend';
}

class ReceivedFriendSuggestState extends FriendSuggestState {
  final FriendSuggestResponse friends;

  ReceivedFriendSuggestState(this.friends);

  @override
  List<Object> get props => [friends];

  @override
  String toString() => 'Received Friend';
}

class ErrorFriendSuggestState extends FriendSuggestState {
  final String errorMessage;

  ErrorFriendSuggestState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Error: ' + errorMessage;
}

class LoadingFriendSuggestState extends FriendSuggestState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Loading';
}
