class FriendEvent {}

class LoadingFriendEvent extends FriendEvent {
  final int index;
  final int count;

  LoadingFriendEvent({required this.index,required this.count});

  @override
  String toString() => 'Load friends';
}

class SearchFriendEvent extends FriendEvent {
  final String query;

  SearchFriendEvent(this.query);

  @override
  String toString() => 'search user';
}
