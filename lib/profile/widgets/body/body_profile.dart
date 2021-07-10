import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/helpers/time_helper.dart';
import 'package:flutter_zalo_bloc/post/bloc/post_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post_response.dart';
import 'package:flutter_zalo_bloc/post/widgets/post_detail/post_detail.dart';
import 'package:flutter_zalo_bloc/profile/widgets/body/post_item.dart';
import 'package:timelines/timelines.dart';

class BodyProfile extends StatelessWidget {
  final PostResponse posts;
  const BodyProfile({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 10.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 1.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.after,
            itemCount: posts.posts.length,
            contentsBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(left: 5.0, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          TimeHelper.readTimestamp(
                              posts.posts[index].createdAt),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        color: Colors.grey,
                      ),
                    ),
                    PostItem(
                        post: posts.posts[index],
                        onClickProfile: null,
                        onDetail: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return PostDetail(
                                  postDetail: posts.posts[index],
                                  onTap: () {
                                    if (!posts.posts[index].isLiked)
                                      return BlocProvider.of<PostBloc>(context)
                                          .add(
                                        LikePostEvent(posts.posts[index]),
                                      );
                                    else
                                      BlocProvider.of<PostBloc>(context).add(
                                        UnLikePostEvent(posts.posts[index]),
                                      );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        onTap: () {
                          if (!posts.posts[index].isLiked)
                            return BlocProvider.of<PostBloc>(context).add(
                              LikeUserPostEvent(posts.posts[index],
                                  posts.posts[index].authorId),
                            );
                          else
                            BlocProvider.of<PostBloc>(context).add(
                              UnLikeUserPostEvent(posts.posts[index],
                                  posts.posts[index].authorId),
                            );
                        },
                        onDelete: () {
                          Navigator.pop(context);
                          BlocProvider.of<PostBloc>(context).add(
                              DeletePostEvent(posts.posts[index].id,
                                  posts.posts[index].authorId));
                        })
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              return DotIndicator(
                size: 12,
                color: Colors.red[300],
              );
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: Colors.blue[300],
            ),
          ),
        ),
      ),
    );
  }
}
