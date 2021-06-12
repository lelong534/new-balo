import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/authentication/models/models.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Authenticated) {
              User user = state.user;

              String? avatar = user.userMainInfo.avatar;
              Widget avatarWidget;
              if (avatar is String) {
                avatarWidget = CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                );
              } else {
                avatarWidget = CircleAvatar(
                  backgroundColor: Colors.brown.shade800,
                  child: Text(user.userMainInfo.name[0].toUpperCase()),
                );
              }

              return ListTile(
                leading: avatarWidget,
                title: Text(user.userMainInfo.name),
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}
