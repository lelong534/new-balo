import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/authentication/widgets/widgets.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: Text('ĐĂNG KÝ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigninScreen(),
                  ),
                );
              },
              child: Text('ĐĂNG NHẬP'),
            ),
          ],
        ),
      ),
    );
  }
}
