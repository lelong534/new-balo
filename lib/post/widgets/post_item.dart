import 'package:chewie/chewie.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/helpers/time_helper.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/image_screen.dart';
import 'package:video_player/video_player.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final dynamic onTap;
  final dynamic onHide;
  final dynamic onBlock;
  final dynamic onDetail;
  final dynamic onClickProfile;
  PostItem(
      {Key? key,
      required this.post,
      required this.onTap,
      required this.onHide,
      required this.onBlock,
      required this.onDetail,
      required this.onClickProfile})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  void dispose() {
    try {
      VideoPlayerController.network(widget.post.video![0]["link"]!).dispose();
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

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
        onPressed: () {
          _showDialog(post);
        },
      ),
    );
  }

  Future<void> _showDialog(Post post) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: widget.onHide,
              child: Text("Ẩn bài viết"),
            ),
            SimpleDialogOption(
              onPressed: () {
                _showBlockDialog();
              },
              child: Text("Chặn người này"),
            )
          ],
        );
      },
    );
  }

  Future<void> _showBlockDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Bạn có chắn chắn muốn chặn người này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('KHÔNG'),
            ),
            TextButton(
              onPressed: widget.onBlock,
              child: Text('CÓ'),
            ),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            height: 240,
            // child: CachedNetworkImage(
            //   placeholder: (context, url) =>
            //       Center(child: CircularProgressIndicator()),
            //   imageUrl: url,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            child: Image.network(
              url,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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

  Widget buildPostVideo(Post post) {
    if (widget.post.video!.length != 0)
      return AspectRatio(
        aspectRatio:
            VideoPlayerController.network(widget.post.video![0]["link"]!)
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
      );
    else
      return Container();
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
            buildPostVideo(widget.post),
            buildPostFooter(widget.post),
            SizedBox(height: 6)
          ],
        ),
      ),
      SizedBox(height: 10)
    ]);
  }
}
