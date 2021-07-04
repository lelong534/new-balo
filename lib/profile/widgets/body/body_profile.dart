import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/helpers/time_helper.dart';
import 'package:flutter_zalo_bloc/post/models/post_response.dart';
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
                      onDetail: null,
                      onTap: null,
                    )
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
