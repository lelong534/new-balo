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
