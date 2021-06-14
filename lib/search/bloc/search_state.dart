part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchSuccess extends SearchState {
  final SearchResponse results;

  SearchSuccess({required this.results});

  @override
  List<Object> get props => [results];
}

class SearchErrorState extends SearchState {
  final String errorMessage;

  SearchErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
