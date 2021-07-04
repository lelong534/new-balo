import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/profile/widgets/profile.dart';
import 'package:flutter_zalo_bloc/search/bloc/search_bloc.dart';
import 'package:flutter_zalo_bloc/search/models/search.dart';
import 'package:flutter_zalo_bloc/search/repositories/search_api_client.dart';
import 'package:flutter_zalo_bloc/search/repositories/search_repository.dart';

class SearchScreen extends SearchDelegate {
  final searchRepository = SearchRepository(searchApiClient: SearchApiClient());

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(EvaIcons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (BuildContext context) =>
          SearchBloc(searchRepository: searchRepository)
            ..add(SearchRequestEvent(query: query)),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchSuccess) {
            List<Search> results = state.results.results;
            if (results.length == 0)
              return Center(child: Text("Không có kết quả"));
            return ListView.builder(
              itemCount: results.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shadowColor: Colors.white12,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return Profile(
                            userId: results[index].id,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        results[index].avatar != "avatar"
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  results[index].avatar,
                                ),
                              )
                            : CircleAvatar(
                                child: Text(
                                    results[index].username[0].toUpperCase()),
                              ),
                        SizedBox(width: 20),
                        Text(
                          results[index].username,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                // IconButton(
                                //   onPressed: () {
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => MessageScreen(
                                //           receiver: UserMainInfo(
                                //             id: results[index].id.toString(),
                                //             name: results[index].username,
                                //             avatar: results[index].avatar,
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                //   icon: Icon(
                                //     EvaIcons.messageCircleOutline,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                    onTap: () {
                                      print("h");
                                    },
                                    child: Text("Kết bạn")),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.blue,
                                    Colors.blue.shade200,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
