import 'package:chewie/chewie.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/helpers/time_helper.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final dynamic onTap;
  final dynamic onDetail;
  final dynamic onClickProfile;
  PostItem(
      {Key? key,
      required this.post,
      required this.onTap,
      required this.onDetail,
      required this.onClickProfile})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  buildPostHeader(Post post) {
    var avatarLink;
    avatarLink = post.authorAvatar;
    return ListTile(
      leading: avatarLink != "avatar"
          ? GestureDetector(
              onTap: () {
                print(post.authorId);
                widget.onClickProfile();
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(avatarLink, scale: 0.1),
              ),
            )
          : GestureDetector(
              onTap: () {
                print(post.authorId);
                widget.onClickProfile();
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
      title: GestureDetector(
        onTap: () {
          widget.onClickProfile();
        },
        child: Text(
          post.authorName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(TimeHelper.readTimestamp(post.createdAt)),
      trailing: IconButton(
        icon: Icon(EvaIcons.moreVerticalOutline),
        onPressed: _showDialog,
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () {},
              child: Text("Xóa bài viết"),
            ),
            SimpleDialogOption(
              onPressed: () {},
              child: Text("Ẩn bài viết"),
            ),
            SimpleDialogOption(
              onPressed: () {},
              child: Text("Chặn người này"),
            )
          ],
        );
      },
    );
  }

  buildPostContent(Post post) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 18),
            child: Text(
              post.described,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  buildPostImage(Post post) {
    if (post.images.length == 0) {
      return Container();
    } else if (post.images.length == 1) {
      return Container(child: buildFullScreenImage(post.images[0]["link"]));
    } else if (post.images.length == 2) {
      return Container(
        child: Row(
          children: <Widget>[
            Expanded(child: buildFullScreenImage(post.images[0]["link"])),
            Expanded(child: buildFullScreenImage(post.images[1]["link"])),
          ],
        ),
      );
    } else if (post.images.length == 3) {
      return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: buildFullScreenImage(post.images[0]["link"])),
                Expanded(child: buildFullScreenImage(post.images[1]["link"])),
              ],
            ),
          ),
          Container(child: buildFullScreenImage(post.images[2]["link"])),
        ]),
      );
    } else if (post.images.length == 4) {
      return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: buildFullScreenImage(post.images[0]["link"])),
                Expanded(child: buildFullScreenImage(post.images[1]["link"])),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: buildFullScreenImage(post.images[2]["link"])),
                Expanded(child: buildFullScreenImage(post.images[3]["link"])),
              ],
            ),
          ),
        ]),
      );
    } else
      return Container();
  }

  buildFullScreenImage(url) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        child: CachedNetworkImage(
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          imageUrl: url,
        ),
      ),
    );
  }

  Widget buildPostFooter(Post post) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 60.0, left: 20.0)),
            GestureDetector(
              onTap: widget.onTap,
              child: Icon(
                post.isLiked ? EvaIcons.heart : EvaIcons.heartOutline,
                size: 28.0,
                color: post.isLiked ? Colors.pink : Colors.black,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5.0)),
            Text(post.like.toString()),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: widget.onDetail,
              child: Icon(
                EvaIcons.messageCircleOutline,
                size: 28.0,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5.0)),
            Text(post.comment.toString()),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            buildPostHeader(widget.post),
            buildPostContent(widget.post),
            buildPostImage(widget.post),
            if (widget.post.video!.length != 0)
              AspectRatio(
                aspectRatio: VideoPlayerController.network(
                        widget.post.video![0]["link"]!)
                    .value
                    .aspectRatio,
                child: Chewie(
                  controller: ChewieController(
                    videoPlayerController: VideoPlayerController.network(
                      widget.post.video![0]["link"]!,
                    ),
                    autoInitialize: true,
                    showOptions: false,
                  ),
                ),
              ),
            buildPostFooter(widget.post),
            SizedBox(height: 6)
          ],
        ),
      ),
      SizedBox(height: 10)
    ]);
  }
}
