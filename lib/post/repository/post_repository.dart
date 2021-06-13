import 'dart:io';

import 'package:flutter_zalo_bloc/post/bloc/post_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/post_response.dart';
import 'package:flutter_zalo_bloc/post/repository/post_api_client.dart';
import 'package:dio/dio.dart';

class PostRepository {
  final PostApiClient postApiClient;

  PostRepository({required this.postApiClient});

  Future<PostState> loadPosts(int index, int count) async {
    PostResponse newState = await postApiClient.getListPosts(index, count);
    return ReceivedPostState(newState);
  }

  Future<PostState> loadPostsByUser(int index, int count, int userId) async {
    PostResponse newState =
        await postApiClient.getListPostsByUser(index, count, userId);
    return ReceivedPostState(newState);
  }

  Future<PostState> likePost(post) async {
    PostResponse newState = await postApiClient.likePost(post);
    return ReceivedPostState(newState);
  }

  Future<PostState> unLikePost(post) async {
    PostResponse newState = await postApiClient.unLikePost(post);
    return ReceivedPostState(newState);
  }

  Future<PostState> addPost(
      List<MultipartFile>? images, File? video, String described) async {
    PostResponse newState =
        await postApiClient.addPost(images, video, described);
    return ReceivedPostState(newState);
  }
}
