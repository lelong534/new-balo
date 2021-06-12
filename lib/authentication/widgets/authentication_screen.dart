import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/authentication/widgets/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool clicked = false;
  void afterIntroComplete() {
    setState(() {
      clicked = true;
    });
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SigninScreen()),
    );
  }

  final List<PageViewModel> pages = [
    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text(
            'ĐẠI HỌC BÁCH KHOA HÀ NỘI',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
      body: "Một tình yêu, một tương lai.",
      image: Image.asset(
        'assets/logo.png',
        width: 100,
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
        descriptionPadding: EdgeInsets.only(left: 20, right: 20),
        imagePadding: EdgeInsets.all(20),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return clicked
        ? SigninScreen()
        : IntroductionScreen(
            pages: pages,
            onDone: () {
              _onIntroEnd(context);
            },
            onSkip: () {
              _onIntroEnd(context);
            },
            showSkipButton: true,
            skip: const Icon(Icons.skip_next),
            next: const Icon(Icons.skip_next),
            done: const Icon(Icons.arrow_forward),
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          );
  }
}
