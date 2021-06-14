import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';

class PostContent extends StatelessWidget {
  final Post post;
  PostContent(this.post);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(left: 18),
            child: Text(
              post.described,
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
