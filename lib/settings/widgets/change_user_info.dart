import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_bloc.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_event.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_state.dart';
import 'package:flutter_zalo_bloc/settings/models/user.dart';
import 'package:flutter_zalo_bloc/settings/repository/user_repository.dart';

class ChangeUserInfo extends StatefulWidget {
  final User? user;
  const ChangeUserInfo({Key? key, this.user}) : super(key: key);

  @override
  _ChangeUserInfoState createState() => _ChangeUserInfoState();
}

class _ChangeUserInfoState extends State<ChangeUserInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) {
        return UserBloc(userRepository: userRepository)
          ..add(LoadingUserEvent());
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserUpdated) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Cập nhật thông tin cá nhân'),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  BlocProvider.of<UserBloc>(context).add(
                    UserChangeInfoEvent(
                      _nameController.text,
                      _descriptionController.text,
                      _addressController.text,
                    ),
                  );
                  Navigator.pop(context);
                },
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Tên',
                            ),
                            controller: _nameController,
                          ),
                          TextFormField(
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Mô tả bản thân',
                            ),
                            controller: _descriptionController,
                          ),
                          TextFormField(
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Địa chỉ',
                            ),
                            controller: _addressController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Cập nhật thông tin cá nhân'),
            ),
          );
        },
      ),
    );
  }
}
