import 'package:flutter_zalo_bloc/search/models/search.dart';

class SearchResponse {
  final List<Search> results;
  final String error;

  SearchResponse(
    this.results,
    this.error,
  );

  SearchResponse.fromJson(Map<String, dynamic> json)
      : results = (json["data"]["friends"] as List)
            .map((i) => new Search.fromJson(i))
            .toList(),
        error = "";

  SearchResponse.withError(String errorValue)
      : results = [],
        error = errorValue;
}
