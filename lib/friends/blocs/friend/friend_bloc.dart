import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend/friend_event.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend/friend_state.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_response.dart';
import 'package:flutter_zalo_bloc/friends/repositories/friend_repository.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepository friendRepository;
  FriendBloc({required this.friendRepository}) : super(FriendState());

  @override
  Stream<FriendState> mapEventToState(FriendEvent event) async* {
    if (event is LoadingFriendEvent) {
      yield LoadingFriendState();
      try {
        yield await _loadFriends(event.index, event.count);
      } catch (e) {
        yield ErrorFriendState(e.toString());
      }
    }
  }

  Future<FriendState> _loadFriends(int index, int count) async {
    FriendResponse newState =
        await FriendRepository().getListFriends(index, count);
    return ReceivedFriendState(newState);
  }
}
