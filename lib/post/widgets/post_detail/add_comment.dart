import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/bloc/comment.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';

class AddComment extends StatelessWidget {
  final Post post;
  final _commentTextController = TextEditingController();

  AddComment(this.post);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: TextField(
                  controller: _commentTextController,
                  style: TextStyle(fontSize: 18),
                  decoration:
                      InputDecoration.collapsed(hintText: "Nhập bình luận"),
                ),
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  EvaIcons.navigation2,
                  color: Colors.blue,
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<CommentBloc>(context)
                    ..add(AddCommentEvent(
                        comment: _commentTextController.text, postId: post.id));
                  _commentTextController.clear();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
