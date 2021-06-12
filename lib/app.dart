import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/authentication/blocs/blocs.dart';
import 'package:flutter_zalo_bloc/authentication/repositories/repositories.dart';
import 'package:flutter_zalo_bloc/authentication/widgets/widgets.dart';
import 'package:flutter_zalo_bloc/homepage/widgets/widgets.dart';
import 'package:flutter_zalo_bloc/splash/widgets/widgets.dart';

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  App({required this.authenticationRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zalo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (_, state) {
          if (state is AuthenticationInitial) {
            return SplashScreen();
          } else if (state is Authenticated) {
            return Homepage();
          } else if (state is Unauthenticated) {
            return AuthenticationScreen();
          }

          return Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        },
      ),
    );
  }
}
