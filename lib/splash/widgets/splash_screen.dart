import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Center(
        child: Text(
          'BKZALO',
          style: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.w600,
              fontFamily: "Contrail"),
        ),
      ),
    );
  }
}
