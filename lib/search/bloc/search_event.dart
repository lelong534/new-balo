part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class LoadingSearchEvent extends SearchEvent {}

class SearchRequestEvent extends SearchEvent {
  final String query;

  SearchRequestEvent({required this.query});
}

class RequestFriendByIdEvent extends SearchEvent {
  final int friendId;
  final String query;
  RequestFriendByIdEvent(this.friendId, this.query);
}
