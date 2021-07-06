import 'package:flutter/material.dart';

class HorizontalItem extends StatelessWidget {
  final Color gradientStart;
  final Color gradientEnd;
  final Icon icon;
  final int count;
  final String title;
  final String subTitle;

  const HorizontalItem({
    Key? key,
    required this.gradientStart,
    required this.gradientEnd,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.count,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(margin: EdgeInsets.only(right: 10), child: this.icon),
          Text(
            this.title + (this.count != 0 ? this.count.toString() + ")" : ''),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "TiWeb",
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            this.gradientStart,
            this.gradientEnd,
          ],
        ),
      ),
    );
  }
}
