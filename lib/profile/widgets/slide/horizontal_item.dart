import 'package:flutter/material.dart';

class HorizontalItem extends StatelessWidget {
  // final ImageProvider<dynamic> image;
  final Color gradientStart;
  final Color gradientEnd;
  final Icon icon;
  final int count;
  final String title;
  final String subTitle;

  const HorizontalItem({
    Key? key,
    // required this.image,
    required this.gradientStart,
    required this.gradientEnd,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.count,
  }) : super(key: key);

  Widget build(BuildContext context) {
    const colorBorder = const Color(0x00FFFFF);
    return Container(
      width: 220,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(margin: EdgeInsets.only(right: 10), child: this.icon),
                Text(
                  this.title +
                      (this.count != 0 ? this.count.toString() + ")" : ''),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  this.subTitle,
                  style: TextStyle(color: Colors.white, fontSize: 11),

                  // overflow: TextOverflow.fade,
                ),
              ],
            ),
          ]),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorBorder),
          // image: this.image != null
          //     ? DecorationImage(
          //         image: this.image,
          //         fit: BoxFit.contain,
          //       )
          //     : null,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              this.gradientStart,
              this.gradientEnd,
            ],
          )),
      height: 50,
    );
  }
}
