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
    return
        // Container(
        //   width: 220,
        //   margin: EdgeInsets.all(5),
        //   padding: EdgeInsets.all(10),
        //   child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Container(margin: EdgeInsets.only(right: 10), child: this.icon),
        //             Text(
        //               this.title +
        //                   (this.count != 0 ? this.count.toString() + ")" : ''),
        //               style: TextStyle(
        //                   color: Colors.white, fontWeight: FontWeight.w500),
        //             ),
        //           ],
        //         ),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Text(
        //               this.subTitle,
        //               style: TextStyle(color: Colors.white, fontSize: 11),
        //             ),
        //           ],
        //         ),
        //       ]),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(color: colorBorder),
        //       gradient: LinearGradient(
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //         colors: [
        //           this.gradientStart,
        //           this.gradientEnd,
        //         ],
        //       )),
        //   height: 50,
        // );
        Container(
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
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
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
