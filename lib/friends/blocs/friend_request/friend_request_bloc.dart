import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend_request/friend_request.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_request.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_request_response.dart';
import 'package:flutter_zalo_bloc/friends/repositories/friend_repository.dart';

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  FriendRequestBloc() : super(FriendRequestState());
  @override
  Stream<FriendRequestState> mapEventToState(FriendRequestEvent event) async* {
    if (event is LoadingFriendRequestEvent) {
      yield LoadingFriendRequestState();
      try {
        yield await _loadFriends(event.index, event.count);
      } catch (e) {
        yield ErrorFriendRequestState(e.toString());
      }
    }

    if (event is AcceptFriendRequestEvent) {
      try {
        yield await _acceptFriend(event.friend);
      } catch (e) {
        yield ErrorFriendRequestState(e.toString());
      }
    }

    if (event is RejectFriendRequestEvent) {
      try {
        yield await _rejectFriend(event.friend);
      } catch (e) {
        yield ErrorFriendRequestState(e.toString());
      }
    }
  }

  Future<FriendRequestState> _loadFriends(int index, int count) async {
    FriendRequestResponse newState =
        await FriendRepository().getListFriendRequest(index, count);
    return ReceivedFriendRequestState(newState);
  }

  Future<FriendRequestState> _acceptFriend(FriendRequest friend) async {
    FriendRequestResponse newState =
        await FriendRepository().acceptFriend(friend.id, 1);
    return ReceivedFriendRequestState(newState);
  }

  Future<FriendRequestState> _rejectFriend(FriendRequest friend) async {
    FriendRequestResponse newState =
        await FriendRepository().rejectFriend(friend.id);
    return ReceivedFriendRequestState(newState);
  }
}
