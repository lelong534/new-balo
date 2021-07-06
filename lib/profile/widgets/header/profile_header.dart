import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/profile/widgets/header/avatar.dart';

class ProfileHeader extends StatelessWidget {
  final ImageProvider coverImage;
  final ImageProvider avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key? key,
      required this.coverImage,
      required this.avatar,
      required this.title,
      required this.subtitle,
      required this.actions})
      : super(key: key);

  dynamic checkUrl(ImageProvider image) {
    try {
      return DecorationImage(image: image, fit: BoxFit.cover);
    } catch (e) {
      return DecorationImage(image: image, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: checkUrl(coverImage),
          ),
          child: new InkWell(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return Modal(
              //           title: "Ảnh bìa",
              //           view: "Xem ảnh bìa",
              //           takeScreen: "Chụp ảnh mới",
              //           takeDevices: "Chọn ảnh từ thiết bị",
              //           img: Image.asset(
              //             'assets/modalCover.jpg',
              //             width: 20,
              //           ));
              //     });
            },
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 130),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Center(
                    child: Avatar(
                      image: avatar,
                      radius: 50,
                      backgroundColor: Colors.white,
                      borderColor: Colors.white,
                      borderWidth: 1.0,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     color: Colors.blue,
                  //     padding: EdgeInsets.all(5),
                  //     margin: EdgeInsets.fromLTRB(
                  //         MediaQuery.of(context).size.width * 0.7, 56, 0, 0),
                  //     child: Text(
                  //       "Nhắn tin",
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 5.0),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
