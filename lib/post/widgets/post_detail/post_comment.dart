import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';

class PostCommentWidget extends StatelessWidget {
  final Post post;

  PostCommentWidget(this.post);

  @override
  Widget build(BuildContext context) {
    return
        // BlocBuilder<CommentBloc, CommentState>(
        //   builder: (context, state) {
        //     if (state is ReceivedCommentState) {
        //       List<Comment> comments = state.comments.comments;
        //       return ListView.builder(
        //         physics: const NeverScrollableScrollPhysics(),
        //         itemCount: comments.length,
        //         shrinkWrap: true,
        //         itemBuilder: (context, index) {
        //           return Column(
        //             children: <Widget>[
        //               Container(
        //                   height: 2,
        //                   color: Colors.black12,
        //                   width: MediaQuery.of(context).size.width * 0.9),
        //               ListTile(
        //                 leading: Padding(
        //                     padding: EdgeInsets.symmetric(vertical: 10),
        //                     child: comments[index].authorAvatar != null
        //                         ? CircleAvatar(
        //                             radius: 16,
        //                             backgroundImage:
        //                                 NetworkImage(comments[index].authorAvatar))
        //                         : CircleAvatar(
        //                             radius: 16,
        //                             child: Text("U"),
        //                           )),
        //                 title: Text(
        //                   comments[index].authorName != null
        //                       ? comments[index].authorName
        //                       : "Người dùng",
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 14,
        //                   ),
        //                 ),
        //                 subtitle: Text(
        //                   comments[index].content,
        //                   style: TextStyle(
        //                     color: Colors.black,
        //                     fontSize: 16,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     }
        //   return CircularProgressIndicator();
        // },
        // );
        Container();
  }
}
