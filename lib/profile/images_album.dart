import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/profile/blocs/image_bloc.dart';
import 'package:flutter_zalo_bloc/profile/blocs/image_event.dart';
import 'package:flutter_zalo_bloc/profile/blocs/image_state.dart';
import 'package:flutter_zalo_bloc/profile/models/image.dart';

class ImagesAlbum extends StatefulWidget {
  final int userId;
  const ImagesAlbum({Key? key, required this.userId}) : super(key: key);

  @override
  _ImagesAlbumState createState() => _ImagesAlbumState();
}

class _ImagesAlbumState extends State<ImagesAlbum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Album ảnh"),
      ),
      body: BlocProvider<ImageBloc>(
        create: (context) {
          return ImageBloc()..add(LoadingImageEvent(widget.userId));
        },
        child: BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            if (state is ReceivedImageState) {
              List<ImageItem> images = state.images.images;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Lưu giữ hoạt động của bạn!!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: images.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(images[index].link),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
