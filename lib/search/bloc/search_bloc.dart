import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/search/models/search_response.dart';
import 'package:flutter_zalo_bloc/search/repositories/repositories.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;
  SearchBloc({required this.searchRepository}) : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchRequestEvent) {
      try {
        SearchResponse results = await searchRepository.search(event.query);
        yield SearchSuccess(results: results);
      } catch (e) {
        yield SearchErrorState(e.toString());
      }
    }

    if (event is RequestFriendByIdEvent) {
      try {
        SearchResponse results =
            await searchRepository.requestFriend(event.friendId, event.query);
        yield RequestFriendSuccessState(results: results);
      } catch (e) {
        yield SearchErrorState(e.toString());
      }
    }
  }
}
