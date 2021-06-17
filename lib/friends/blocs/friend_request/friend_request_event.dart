import 'package:flutter_zalo_bloc/friends/models/friend_request.dart';

abstract class FriendRequestEvent {}

class LoadingFriendRequestEvent extends FriendRequestEvent {
  final int index;
  final int count;

  LoadingFriendRequestEvent({required this.index,required this.count});

  @override
  String toString() => 'Load friends requests';
}

class AcceptFriendRequestEvent extends FriendRequestEvent {
  final FriendRequest friend;

  AcceptFriendRequestEvent(this.friend);

  @override
  String toString() => 'Accept friend';
}

class RejectFriendRequestEvent extends FriendRequestEvent {
  final FriendRequest friend;

  RejectFriendRequestEvent(this.friend);

  @override
  String toString() => 'Reject friend';
}
