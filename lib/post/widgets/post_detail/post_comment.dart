import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/bloc/comment.dart';
import 'package:flutter_zalo_bloc/post/models/comment.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';

class PostCommentWidget extends StatelessWidget {
  final Post post;

  PostCommentWidget(this.post);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is ReceivedCommentState) {
          List<Comment> comments = state.comments.comments;
          return Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 15),
                  Text(
                    "Hiển thị " + comments.length.toString() + " bình luận",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 3),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      // Container(
                      //     height: 2,
                      //     color: Colors.black12,
                      //     width: MediaQuery.of(context).size.width * 0.9),
                      ListTile(
                        leading: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: comments[index].authorAvatar != null
                              ? CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      comments[index].authorAvatar))
                              : CircleAvatar(
                                  radius: 16,
                                  child: Text("U"),
                                ),
                        ),
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comments[index].authorName != null
                                      ? comments[index].authorName
                                      : "Người dùng",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  comments[index].content,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
