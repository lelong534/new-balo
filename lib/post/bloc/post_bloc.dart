import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/post/models/post.dart';
import 'package:flutter_zalo_bloc/post/models/post_response.dart';
import 'package:flutter_zalo_bloc/post/repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(PostState());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is LoadingPostEvent) {
      yield LoadingPostState();
      try {
        yield await postRepository.loadPosts(event.index, event.count);
      } catch (e) {
        yield ErrorPostState(e.toString());
      }
    }

    if (event is LoadingMorePostEvent) {
      try {
        yield await postRepository.loadPosts(event.index, event.count);
      } catch (e) {
        yield ErrorPostState(e.toString());
      }
    }

    if (event is LikePostEvent) {
      try {
        yield await postRepository.likePost(event.post);
      } catch (e) {
        yield ErrorPostState(e.toString());
      }
    }

    if (event is UnLikePostEvent) {
      try {
        yield await postRepository.unLikePost(event.post);
      } catch (e) {
        yield ErrorPostState(e.toString());
      }
    }

    if (event is AddPostEvent) {
      try {
        yield await postRepository.addPost(
            event.images, event.video, event.description);
      } catch (e) {
        yield ErrorPostState(e.toString());
      }
    }

    if (event is LoadingPostByUserEvent) {
      try {
        yield await postRepository.loadPostsByUser(
            event.index, event.count, event.userId);
      } catch (e) {
        yield ErrorPostState(e.toString());
      }
    }
  }
}
