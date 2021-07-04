import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/bloc/post_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post_response.dart';
import 'package:flutter_zalo_bloc/post/repository/post_api_client.dart';
import 'package:flutter_zalo_bloc/post/repository/post_repository.dart';
import 'package:flutter_zalo_bloc/post/widgets/add_post.dart';
import 'package:flutter_zalo_bloc/profile/widgets/body/add_post.dart';
import 'package:flutter_zalo_bloc/profile/widgets/body/body_profile.dart';
import 'package:flutter_zalo_bloc/profile/widgets/slide/horizontal_list_asset.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_bloc.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_event.dart';
import 'package:flutter_zalo_bloc/settings/blocs/user_state.dart';
import 'package:flutter_zalo_bloc/settings/models/user_response.dart';
import 'package:flutter_zalo_bloc/settings/repository/user_repository.dart';

import 'header/profile_header.dart';

class Profile extends StatefulWidget {
  final int userId;

  Profile({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final postRepository = PostRepository(postApiClient: PostApiClient());
  final userRepository = UserRepository();

  _ProfileState();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (BuildContext context) =>
              PostBloc(postRepository: postRepository)
                ..add(LoadingPostByUserEvent(
                    index: 0, count: 20, userId: widget.userId)),
        ),
        BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(userRepository: userRepository)
                ..add(LoadUserProfile(userId: widget.userId)),
        )
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state is UserDetailLoadSuccess) {
                  UserResponse user = state.user;
                  if (user.user.avatar != "avatar")
                    return ProfileHeader(
                      avatar: NetworkImage(user.user.avatar, scale: 0.1),
                      coverImage:
                          NetworkImage(user.user.coverImage, scale: 0.1),
                      title: user.user.name,
                      subtitle: user.user.description,
                      actions: [],
                    );
                  else
                    return ProfileHeader(
                      avatar: AssetImage('assets/avatar.png'),
                      coverImage: AssetImage('assets/avatar.png'),
                      title: user.user.name,
                      subtitle: user.user.description,
                      actions: [],
                    );
                }
                return ProfileHeader(
                  avatar: AssetImage('assets/avatar.png'),
                  coverImage: AssetImage('assets/avatar.png'),
                  title: "",
                  subtitle: "Thêm giới thiệu bản thân",
                  actions: [],
                );
              }),
              const SizedBox(height: 10.0),
              HorizontalListAsset(),
              BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                if (state is ReceivedPostState) {
                  PostResponse posts = state.posts;
                  return Column(
                    children: <Widget>[
                      AddPostProfile(
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
                      BodyProfile(posts: posts),
                    ],
                  );
                }
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
