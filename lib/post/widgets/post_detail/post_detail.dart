import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/bloc/post_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:flutter_zalo_bloc/post/repository/repositories.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/add_comment.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_comment.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_content.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_footer.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_header.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_image.dart';

class PostDetail extends StatefulWidget {
  final Post postDetail;
  final Function onTap;

  PostDetail({
    Key? key,
    required this.postDetail,
    required this.onTap,
  }) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final postRepository = PostRepository(postApiClient: PostApiClient());
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
            create: (context) => PostBloc(postRepository: postRepository)),
        // BlocProvider<CommentBloc>(
        //     create: (context) => CommentBloc()
        //       ..add(
        //           LoadingCommentEvent(index: 0, postId: widget.postDetail.id))),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bình luận"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    PostHeader(widget.postDetail),
                    PostContent(widget.postDetail),
                    PostImage(widget.postDetail),
                    PostFooter(post: widget.postDetail, onTap: widget.onTap),
                    PostCommentWidget(widget.postDetail),
                  ],
                ),
              ),
            ),
            AddComment(widget.postDetail),
            SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
