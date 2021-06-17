import 'package:flutter/material.dart';

class AddPostProfile extends StatelessWidget {
  final Function onTap;
  const AddPostProfile({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(25, 5, 20, 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20, left: 10)),
                InkWell(
                  child: new Text(
                    "Bạn đang nghĩ gì",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  height: 25.0,
                  width: 1.0,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(left: 120.0, right: 10.0),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.panorama, color: Colors.green),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
