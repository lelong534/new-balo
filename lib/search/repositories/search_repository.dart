import 'package:flutter_zalo_bloc/search/bloc/search_bloc.dart';
import 'package:flutter_zalo_bloc/search/models/search_response.dart';
import 'package:flutter_zalo_bloc/search/repositories/search_api_client.dart';

class SearchRepository {
  final SearchApiClient searchApiClient;

  SearchRepository({required this.searchApiClient});

  Future<SearchResponse> search(String keyword) async {
    SearchResponse results = await searchApiClient.search(keyword);
    return results;
  }
}
