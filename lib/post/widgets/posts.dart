import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/bloc/post_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:flutter_zalo_bloc/post/repository/post_api_client.dart';
import 'package:flutter_zalo_bloc/post/repository/post_repository.dart';
import 'package:flutter_zalo_bloc/post/widgets/add_post.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_detail.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_item.dart';
import 'package:flutter_zalo_bloc/profile/widgets/profile.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  int index = 0;
  int count = 20;
  final postRepository = PostRepository(postApiClient: PostApiClient());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (context) {
        return PostBloc(postRepository: postRepository)
          ..add(LoadingPostEvent(index: index, count: count));
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is LoadingPostState) {
            return Container(
              color: Colors.white,
              height: 80,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Hôm nay bạn thế nào?",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return AddPost(
                                  onSave: (images, video, description) {
                                    BlocProvider.of<PostBloc>(context).add(
                                      AddPostEvent(
                                        images: images,
                                        video: video,
                                        description: description,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CircularProgressIndicator()
                ],
              ),
            );
          }
          if (state is ReceivedPostState) {
            List<Post> posts = state.posts.posts;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Hôm nay bạn thế nào?",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return AddPost(
                                  onSave: (images, video, description) {
                                    BlocProvider.of<PostBloc>(context).add(
                                      AddPostEvent(
                                        images: images,
                                        video: video,
                                        description: description,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (BuildContext context, index) {
                        final post = posts[index];
                        return PostItem(
                          post: post,
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
                          onDetail: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return PostDetail(
                                    postDetail: post,
                                    onTap: () {
                                      if (!post.isLiked)
                                        return BlocProvider.of<PostBloc>(
                                                context)
                                            .add(
                                          LikePostEvent(post),
                                        );
                                      else
                                        BlocProvider.of<PostBloc>(context).add(
                                          UnLikePostEvent(post),
                                        );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          onClickProfile: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return Profile(
                                    userId: post.authorId,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      itemCount: posts.length,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PostBloc>(context)
                        ..add(LoadingMorePostEvent(
                            index: index, count: count + 20));
                    },
                    child: Text(
                      "Xem thêm",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.white54;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            color: Colors.white,
            height: 80,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Hôm nay bạn thế nào?",
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return AddPost(
                          onSave: (images, video, description) {
                            BlocProvider.of<PostBloc>(context).add(
                              AddPostEvent(
                                images: images,
                                video: video,
                                description: description,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
