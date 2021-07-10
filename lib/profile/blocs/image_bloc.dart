import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/profile/blocs/image_event.dart';
import 'package:flutter_zalo_bloc/profile/blocs/image_state.dart';
import 'package:flutter_zalo_bloc/profile/models/image_response.dart';
import 'package:flutter_zalo_bloc/profile/repository/image_repository.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageState());

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is LoadingImageEvent) {
      yield LoadingImageState();
      try {
        yield await _loadImages(event.userId);
      } catch (e) {
        yield ErrorImageState(e.toString());
      }
    }
  }

  Future<ImageState> _loadImages(int userId) async {
    ImageResponse newState = await ImageRepository().getListImages(userId);
    return ReceivedImageState(newState);
  }
}
