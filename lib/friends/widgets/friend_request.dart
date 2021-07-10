import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend_request/friend_request.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend_request/friend_request_bloc.dart';
import 'package:flutter_zalo_bloc/friends/models/friend_request.dart';
import 'package:flutter_zalo_bloc/friends/widgets/friend_suggest.dart';

class FriendRequestScreen extends StatefulWidget {
  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  int index = 0;
  int count = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lời mời kết bạn"),
      ),
      body: BlocProvider<FriendRequestBloc>(
        create: (context) {
          return FriendRequestBloc()
            ..add(LoadingFriendRequestEvent(index: index, count: count));
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<FriendRequestBloc, FriendRequestState>(
                    builder: (context, state) {
                      if (state is ReceivedFriendRequestState) {
                        List<FriendRequest> friends =
                            state.friends.friendRequests;
                        if (friends.length != 0) {
                          return ListView.builder(
                            itemCount: friends.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: <Widget>[
                                    friends[index].avatar != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                friends[index].avatar!))
                                        : CircleAvatar(child: Text("U")),
                                    SizedBox(width: 20),
                                    Text(friends[index].username!,
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
                                                            FriendRequestBloc>(
                                                        context)
                                                    .add(
                                                        AcceptFriendRequestEvent(
                                                            friends[index]));
                                              },
                                              child: Text(
                                                "ĐỒNG Ý",
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
                                    IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.blue),
                                        onPressed: () {
                                          BlocProvider.of<FriendRequestBloc>(
                                                  context)
                                              .add(RejectFriendRequestEvent(
                                                  friends[index]));
                                        },
                                        padding: EdgeInsets.all(0))
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              "Danh sách lời mời kết bạn đang trống",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      } else
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                    },
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendSuggestScreen(),
                      ),
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text("TÌM THÊM BẠN",
                          style: TextStyle(color: Colors.white))),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.lightBlue.shade200;
                    }),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
