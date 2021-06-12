import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                context.read<AuthenticationBloc>().add(SignOut());
              },
              child: Text('CÓ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (_, state) {
            return LoadingOverlay(
              isLoading: state is UnauthenticationRequestLoading,
              child: Center(
                child: ElevatedButton(
                  onPressed: _showMyDialog,
                  child: Text('Đăng xuất'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
