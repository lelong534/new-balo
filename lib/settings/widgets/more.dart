import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/authentication_bloc.dart';
import 'package:flutter_zalo_bloc/profile/widgets/modal/modal.dart';
import 'package:flutter_zalo_bloc/profile/widgets/profile.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_bloc.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_event.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_state.dart';
import 'package:flutter_zalo_bloc/settings/repository/user_repository.dart';
import 'package:flutter_zalo_bloc/settings/widgets/change_user_info.dart';
import 'package:flutter_zalo_bloc/settings/widgets/user_infomation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(create: (context) {
      return UserBloc(userRepository: UserRepository())
        ..add(LoadingUserEvent());
    }, child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserUpdated) {
        var user = state.user.user;
        return ListView(
          children: <Widget>[
            ListTile(
              leading: user.avatar != "avatar"
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar, scale: 0.1),
                      radius: 30,
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.png'),
                      radius: 30,
                    ),
              title: GestureDetector(
                child: Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              subtitle: Text("Xem trang cá nhân"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return Profile(userId: state.user.user.id);
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Thông tin'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return UserInfomation(user: state.user.user);
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Đổi ảnh đại diện'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Modal(
                      title: "Ảnh đại diện",
                      takeScreen: "Chụp ảnh mới",
                      takeDevices: "Chọn ảnh từ thiết bị",
                      img: Image.asset(
                        'assets/modalAvatar.jpg',
                        width: 20,
                      ),
                      onSelectGallery: () async {
                        PickedFile? pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          File file = File(pickedFile.path);
                          MultipartFile toImage = await MultipartFile.fromFile(
                              file.path,
                              filename: 'avartar.png');
                          BlocProvider.of<UserBloc>(context)
                              .add(UserChangeAvatarEvent(toImage, state.user));
                          Navigator.pop(context);
                        }
                      },
                      onSelectCamera: () async {
                        PickedFile? pickedFile = await ImagePicker().getImage(
                          source: ImageSource.camera,
                        );
                        if (pickedFile != null) {
                          File file = File(pickedFile.path);
                          MultipartFile toImage = await MultipartFile.fromFile(
                              file.path,
                              filename: 'avartar.png');
                          BlocProvider.of<UserBloc>(context)
                              .add(UserChangeAvatarEvent(toImage, state.user));
                          Navigator.pop(context);
                        }
                      },
                      user: state.user.user,
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('Đổi ảnh bìa'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return Modal(
                      title: "Đổi ảnh bìa",
                      takeScreen: "Chụp ảnh mới",
                      takeDevices: "Chọn ảnh từ thiết bị",
                      img: Image.asset(
                        'assets/modalAvatar.jpg',
                        width: 20,
                      ),
                      onSelectGallery: () async {
                        PickedFile? pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          File file = File(pickedFile.path);
                          MultipartFile toImage = await MultipartFile.fromFile(
                              file.path,
                              filename: 'avartar.png');
                          BlocProvider.of<UserBloc>(context)
                              .add(UserChangeCoverImageEvent(toImage));
                          Navigator.pop(context);
                        }
                      },
                      onSelectCamera: () async {
                        PickedFile? pickedFile = await ImagePicker().getImage(
                          source: ImageSource.camera,
                        );
                        if (pickedFile != null) {
                          File file = File(pickedFile.path);
                          MultipartFile toImage = await MultipartFile.fromFile(
                              file.path,
                              filename: 'avartar.png');
                          BlocProvider.of<UserBloc>(context)
                              .add(UserChangeCoverImageEvent(toImage));
                          Navigator.pop(context);
                        }
                      },
                      user: state.user.user,
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('Cập nhật thông tin cá nhân'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return ChangeUserInfo(user: state.user.user);
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Cài đặt',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[400],
                    fontWeight: FontWeight.w700),
              ),
              dense: true,
            ),
            ListTile(
              title: Text('Quản lý tài khoản'),
            ),
            ListTile(
              title: Text('Cài đặt chung'),
            ),
            ListTile(
              title: Text("Đăng xuất"),
              onTap: _showMyDialog,
            ),
          ],
        );
      }
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/avatar.png'),
          radius: 30,
        ),
        title: Text(
          "Người dùng",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text("Xem trang cá nhân"),
      );
    }));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Bạn muốn đăng xuất tài khoản này'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('KHÔNG'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
              },
              child: Text('CÓ'),
            ),
          ],
        );
      },
    );
  }
}
