import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend/friend.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend/friend_bloc.dart';
import 'package:flutter_zalo_bloc/friends/blocs/friend/friend_event.dart';
import 'package:flutter_zalo_bloc/friends/models/friend.dart';
import 'package:flutter_zalo_bloc/friends/repositories/friend_repository.dart';
import 'package:flutter_zalo_bloc/friends/widgets/friend_request.dart';
import 'package:flutter_zalo_bloc/message/widgets/message_screen.dart';
import 'package:flutter_zalo_bloc/profile/widgets/profile.dart';

class Contact extends StatefulWidget {
  static String routeName = "contact";
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FriendBloc>(
        create: (context) {
          return FriendBloc(friendRepository: FriendRepository())
            ..add(LoadingFriendEvent(count: 50, index: 0));
        },
        child: Column(children: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
              shadowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.white;
              }),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.black12;
                return Colors.white;
              }),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new FriendRequestScreen()),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: Icon(EvaIcons.peopleOutline, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Text("Lời mời kết bạn",
                      style: TextStyle(color: Colors.black, fontSize: 16))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                "Danh sách bạn bè",
                style: TextStyle(),
              ),
            ),
          ),
          BlocBuilder<FriendBloc, FriendState>(builder: (context, state) {
            if (state is ReceivedFriendState) {
              List<Friend> friends = state.friends.friends;

              return ListView.builder(
                itemCount: friends.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildFriendItem(friends[index]);
                },
              );
            }
            return Container();
          })
        ]));
  }

  Widget _buildFriendItem(Friend friend) {
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
                userId: friend.id,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            friend.avatar != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(friend.avatar.toString()))
                : CircleAvatar(
                    child: Text(friend.username.toString()[0].toUpperCase())),
            SizedBox(width: 20),
            Text(
                friend.username != null
                    ? friend.username.toString()
                    : "Người dùng",
                style: TextStyle(color: Colors.black, fontSize: 16)),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(
                      receiver: UserMainInfo(
                        id: friend.id.toString(),
                        name: friend.username.toString(),
                        avatar: friend.avatar,
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.sms_outlined,
                size: 28,
              ),
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
