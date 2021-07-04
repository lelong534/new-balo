import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/image_screen.dart';

class PostImage extends StatefulWidget {
  final Post post;
  PostImage(this.post);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  buildFullScreenImage(url) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: CachedNetworkImage(
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            imageUrl: url,
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageScreen(url);
          }));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.images.length == 0) {
      return Container();
    } else if (widget.post.images.length == 1) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: buildFullScreenImage(widget.post.images[0]["link"]),
      );
    } else if (widget.post.images.length == 2) {
      return Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: buildFullScreenImage(widget.post.images[0]["link"])),
            Expanded(
                child: buildFullScreenImage(widget.post.images[1]["link"])),
          ],
        ),
      );
    } else if (widget.post.images.length == 3) {
      return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: buildFullScreenImage(widget.post.images[0]["link"])),
                Expanded(
                    child: buildFullScreenImage(widget.post.images[1]["link"])),
              ],
            ),
          ),
          Container(child: buildFullScreenImage(widget.post.images[2]["link"])),
        ]),
      );
    } else if (widget.post.images.length == 4) {
      return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: buildFullScreenImage(widget.post.images[0]["link"])),
                Expanded(
                    child: buildFullScreenImage(widget.post.images[1]["link"])),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: buildFullScreenImage(widget.post.images[2]["link"])),
                Expanded(
                    child: buildFullScreenImage(widget.post.images[3]["link"])),
              ],
            ),
          ),
        ]),
      );
    } else
      return Container();
  }
}
