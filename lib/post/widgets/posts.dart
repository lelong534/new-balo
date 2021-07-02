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
  int count = 50;
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
                                  onSave: (images, description) {
                                    BlocProvider.of<PostBloc>(context).add(
                                      AddPostEvent(
                                        images: images,
                                        description: description,
                                      ),
                                    );
                                  },
                                  onSaveVideo: (video, description) {
                                    BlocProvider.of<PostBloc>(context).add(
                                      AddPostVideoEvent(
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

          Future<void> _getData() async {
            BlocProvider.of<PostBloc>(context)
              ..add(LoadingPostEvent(index: 0, count: 50));
          }

          if (state is ReceivedPostState) {
            List<Post> posts = state.posts.posts;
            return RefreshIndicator(
              onRefresh: _getData,
              child: SingleChildScrollView(
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
                                    onSave: (images, description) {
                                      BlocProvider.of<PostBloc>(context).add(
                                        AddPostEvent(
                                          images: images,
                                          description: description,
                                        ),
                                      );
                                    },
                                    onSaveVideo: (video, description) {
                                      BlocProvider.of<PostBloc>(context).add(
                                        AddPostVideoEvent(
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
                                          BlocProvider.of<PostBloc>(context)
                                              .add(
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
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<PostBloc>(context)
                          ..add(LoadingMorePostEvent(
                              index: index, count: count + 20));
                      },
                      child: Icon(Icons.replay),
                    ),
                    SizedBox(height: 5)
                  ],
                ),
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
                          onSave: (images, description) {
                            BlocProvider.of<PostBloc>(context).add(
                              AddPostEvent(
                                images: images,
                                description: description,
                              ),
                            );
                          },
                          onSaveVideo: (video, description) {
                            BlocProvider.of<PostBloc>(context).add(
                              AddPostVideoEvent(
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
