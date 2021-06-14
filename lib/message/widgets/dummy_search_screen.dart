import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';
import 'package:flutter_zalo_bloc/message/widgets/message_screen.dart';

class DummySearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dummyData = [
      {'id': '103', 'name': 'Tường Vy', 'avatar': null},
      {'id': '104', 'name': 'Minh Ngọc', 'avatar': null},
      {'id': '105', 'name': 'Quỳnh Mai', 'avatar': null},
      {'id': '106', 'name': 'Bảo Thy', 'avatar': null},
      {'id': '107', 'name': 'Kiều Trang', 'avatar': null},
      {'id': '113', 'name': 'Thắng', 'avatar': null},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy Search'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            User user = state.user;
            final filterDummyData = dummyData
                .where((element) => element['id'] != user.userMainInfo.id)
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: filterDummyData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Text(
                      filterDummyData[index]['name']![0].toUpperCase(),
                    ),
                  ),
                  title: Text(filterDummyData[index]['name'].toString()),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            receiver: UserMainInfo(
                              id: filterDummyData[index]['id'].toString(),
                              name: filterDummyData[index]['name'].toString(),
                              avatar:
                                  filterDummyData[index]['avatar']?.toString(),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.chat_rounded),
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
}
