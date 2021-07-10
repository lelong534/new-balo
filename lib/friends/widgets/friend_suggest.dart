import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend_suggest/friend_suggest.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_suggest.dart';

class FriendSuggestScreen extends StatefulWidget {
  static String routeName = 'friend_suggest_screen';
  @override
  _FriendSuggestScreenState createState() => _FriendSuggestScreenState();
}

class _FriendSuggestScreenState extends State<FriendSuggestScreen> {
  int index = 0;
  int count = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gợi ý kết bạn"),
      ),
      body: BlocProvider<FriendSuggestBloc>(
        create: (context) {
          return FriendSuggestBloc()
            ..add(LoadingFriendSuggestEvent(index: index, count: count));
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<FriendSuggestBloc, FriendSuggestState>(
                    builder: (context, state) {
                      if (state is ReceivedFriendSuggestState) {
                        List<FriendSuggest> friends =
                            state.friends.friendSuggests;

                        return ListView.builder(
                          itemCount: friends.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            final user = friends[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: <Widget>[
                                  user.avatar != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user.avatar!))
                                      : CircleAvatar(child: Text("U")),
                                  SizedBox(width: 20),
                                  Text(user.username!,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                  Spacer(),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<
                                                  FriendSuggestBloc>(context)
                                                ..add(RequestFriendSuggestEvent(
                                                    user));
                                            },
                                            child: Text(
                                              "Kết bạn",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
