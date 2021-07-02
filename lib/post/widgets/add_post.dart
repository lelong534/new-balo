import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:video_player/video_player.dart';

class AddPost extends StatefulWidget {
  final Function onSave;
  final Function onSaveVideo;

  AddPost({Key? key, required this.onSave, required this.onSaveVideo})
      : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? video;
  List<Asset> imagesAsset = <Asset>[];
  String errorText = "No Error Dectected";
  final _describedController = TextEditingController();
  List<MultipartFile> imagesFile = [];
  VideoPlayerController? _controller;
  bool hasImage = false;
  bool hasVideo = false;

  Widget buildGridView() {
    if (video != null && mounted) {
      return Container(
        height: 100,
        child: Chewie(
          controller: ChewieController(
            videoPlayerController: VideoPlayerController.file(video!),
            autoInitialize: true,
          ),
        ),
      );
    } else if (imagesAsset.length > 0)
      return GridView.count(
        crossAxisCount: 2,
        children: List.generate(imagesAsset.length, (index) {
          Asset asset = imagesAsset[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container();
  }

  Future<void> _loadImages() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    if (hasVideo) return;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarColor: "#b2b2b2",
          actionBarTitleColor: "#FFFFFF",
          statusBarColor: '#b2b2b2',
          selectionLimitReachedText: "Số lượng ảnh đạt giới hạn",
        ),
      );
    } on Exception catch (e) {
      resultList = [];
      error = e.toString();
    }

    if (!mounted) return;

    if (resultList.length > 0) {
      for (var asset in resultList) {
        ByteData byteData = await asset.getByteData(quality: 80);

        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: 'test.jpg',
        );
        imagesFile.add(multipartFile);
      }
    }

    setState(() {
      imagesAsset = resultList;
      hasImage = true;
      errorText = error;
    });
  }

  Future<void> _loadVideo() async {
    if (hasImage) return;

    final PickedFile? file =
        await ImagePicker().getVideo(source: ImageSource.gallery);

    if (file != null) {
      File fileMedia = File(file.path);
      setState(() {
        video = fileMedia;
        hasVideo = true;
      });

      _controller = VideoPlayerController.file(video!)..initialize();
    }
  }

  Future<void> _submitPost() async {
    if (_describedController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hãy nhập thêm nội dung bài viết")),
      );
    } else if (hasVideo && !hasImage) {
      _controller?.dispose();
      widget.onSaveVideo(video, _describedController.text);
      Navigator.pop(context);
    } else if (hasImage && !hasVideo) {
      widget.onSave(imagesFile, _describedController.text);
      Navigator.pop(context);
    }
  }

  clearImage() {
    setState(() {
      imagesFile = [];
      hasImage = false;
      hasVideo = false;
      _controller?.dispose();
      Navigator.pop(context);
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          'Tạo bài viết',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextButton(
              onPressed: _submitPost,
              child: Text(
                'ĐĂNG',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _describedController,
                decoration: InputDecoration(
                  hintText: "Bạn đang nghĩ gì?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Expanded(
            child: buildGridView(),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    child: Text("Chọn ảnh"),
                    onPressed: _loadImages,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor:
                          hasVideo ? Colors.blue.shade100 : Colors.blue,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    child: Text("Chọn video"),
                    onPressed: _loadVideo,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor:
                          hasImage ? Colors.blue.shade100 : Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
