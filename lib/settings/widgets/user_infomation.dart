import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/settings/models/user.dart';

class UserInfomation extends StatelessWidget {
  final User? user;
  const UserInfomation({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin cá nhân"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Tên"),
            trailing: Text(user!.name),
          ),
          ListTile(
            title: Text("Điện thoại"),
            trailing: Text(
              user!.phonenumber.trim(),
            ),
          ),
          ListTile(
            title: Text("Tỉnh/ Thành phố"),
            trailing: Text(user!.address),
          ),
          ListTile(
            title: Text("Giới thiệu"),
            trailing: Text(user!.description),
          ),
        ],
      ),
    );
  }
}
