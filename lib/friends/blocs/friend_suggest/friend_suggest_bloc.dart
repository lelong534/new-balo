import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend_suggest/friend_suggest.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_suggest.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_suggest_response.dart';
import 'package:flutter_zalo_bloc/friends/repositories/friend_repository.dart';

class FriendSuggestBloc extends Bloc<FriendSuggestEvent, FriendSuggestState> {
  FriendSuggestBloc() : super(FriendSuggestState());

  @override
  Stream<FriendSuggestState> mapEventToState(FriendSuggestEvent event) async* {
    if (event is LoadingFriendSuggestEvent) {
      yield LoadingFriendSuggestState();
      try {
        yield await _loadFriends(event.index, event.count);
      } catch (e) {
        yield ErrorFriendSuggestState(e.toString());
      }
    }

    if (event is RequestFriendSuggestEvent) {
      try {
        yield await _requestFriend(event.friend);
      } catch (e) {
        yield ErrorFriendSuggestState(e.toString());
      }
    }
  }

  Future<FriendSuggestState> _loadFriends(int index, int count) async {
    FriendSuggestResponse newState =
        await FriendRepository().getListSuggestRequest(index, count);
    return ReceivedFriendSuggestState(newState);
  }

  Future<FriendSuggestState> _requestFriend(FriendSuggest friend) async {
    FriendSuggestResponse newState =
        await FriendRepository().requestFriend(friend.id);
    return ReceivedFriendSuggestState(newState);
  }
}
