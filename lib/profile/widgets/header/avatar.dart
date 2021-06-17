import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final ImageProvider image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;
  // final String linkAvatar;

  const Avatar(
      {Key? key,
      required this.image,
      this.borderColor = Colors.grey,
      required this.backgroundColor,
      this.radius = 30,
      // this.linkAvatar,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: GestureDetector(
          onTap: () {
            //do what you want here
            // showDialog(
            // context: context,
            // builder: (BuildContext context) {
            // return Modal(
            //   title: "Ảnh đại diện",
            //   view: "Xem ảnh đại diện",
            //   takeScreen: "Chụp ảnh mới",
            //   takeDevices: "Chọn ảnh từ thiết bị",
            //   img: Image.asset(
            //     'assets/modalAvatar.jpg',
            //     width: 20,
            //   ),
            //   // linkAvatar: linkAvatar,
            // );
            // });
          },
          child: CircleAvatar(
            radius: radius - borderWidth,
            backgroundImage: image,
            onBackgroundImageError: (_, __) {
              print("ERROR");
            },
          ),
        ),
      ),
    );
  }
}
