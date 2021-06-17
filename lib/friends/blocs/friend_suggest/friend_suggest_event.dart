import 'package:flutter_zalo_bloc/friends/models/friend_suggest.dart';

class FriendSuggestEvent {}

class LoadingFriendSuggestEvent extends FriendSuggestEvent {
  final int index;
  final int count;

  LoadingFriendSuggestEvent({required this.index, required this.count});

  @override
  String toString() => 'Load friends Suggests';
}

class RequestFriendSuggestEvent extends FriendSuggestEvent {
  final FriendSuggest friend;

  RequestFriendSuggestEvent(this.friend);

  @override
  String toString() => 'Accept friend';
}
