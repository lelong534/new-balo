import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/bloc/post_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';

class PostFooter extends StatelessWidget {
  final Post post;
  final Function onTap;

  PostFooter({required this.post,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state is ReceivedPostState) {
        final postState =
            state.posts.posts.firstWhere((item) => item.id == post.id);
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 60.0, left: 20.0)),
                GestureDetector(
                  onTap: () {
                    if (!postState.isLiked)
                      return BlocProvider.of<PostBloc>(context).add(
                        LikePostEvent(post),
                      );
                    else
                      BlocProvider.of<PostBloc>(context).add(
                        UnLikePostEvent(post),
                      );
                  },
                  child: Icon(
                    postState.isLiked ? EvaIcons.heart : EvaIcons.heartOutline,
                    size: 28.0,
                    color: postState.isLiked ? Colors.pink : Colors.black,
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 5.0)),
                Text(postState.like.toString()),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                Icon(
                  EvaIcons.messageCircleOutline,
                  size: 28.0,
                ),
                Padding(padding: EdgeInsets.only(right: 5.0)),
                Text(postState.comment.toString()),
              ],
            ),
          ],
        );
      }
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 60.0, left: 20.0)),
              GestureDetector(
                onTap: () {
                  if (!post.isLiked)
                    return BlocProvider.of<PostBloc>(context).add(
                      LikePostEvent(post),
                    );
                  else
                    BlocProvider.of<PostBloc>(context).add(
                      UnLikePostEvent(post),
                    );
                },
                child: Icon(
                  post.isLiked ? EvaIcons.heart : EvaIcons.heartOutline,
                  size: 28.0,
                  color: post.isLiked ? Colors.pink : Colors.black,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 5.0)),
              Text(post.like.toString()),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              Icon(
                EvaIcons.messageCircleOutline,
                size: 28.0,
              ),
              Padding(padding: EdgeInsets.only(right: 5.0)),
              Text(post.comment.toString()),
            ],
          ),
        ],
      );
    });
  }
}
