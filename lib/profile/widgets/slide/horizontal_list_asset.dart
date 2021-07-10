import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/profile/images_album.dart';
import 'package:flutter_zalo_bloc/profile/widgets/slide/horizontal_item.dart';

class HorizontalListAsset extends StatelessWidget {
  const HorizontalListAsset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return ImagesAlbum(userId: 0);
                  },
                ),
              );
            },
            child: HorizontalItem(
              title: "Ảnh của tôi",
              subTitle: "Xem tất cả ảnh và video\nđã đăng",
              count: 0,
              gradientStart: Colors.yellow,
              gradientEnd: Colors.yellow.shade100,
              icon: Icon(Icons.panorama, color: Colors.black),
            ),
          ),
          HorizontalItem(
            title: "Video của tôi",
            subTitle: "Xem các video đã đăng",
            count: 0,
            icon: Icon(Icons.videocam, color: Colors.black),
            gradientStart: Color.fromARGB(255, 255, 153, 130),
            gradientEnd: Color.fromARGB(100, 255, 153, 130),
          )
        ],
      ),
    );
  }
}
