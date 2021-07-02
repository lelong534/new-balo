import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zalo_bloc/post/models/comment_response.dart';
import 'package:flutter_zalo_bloc/post/repository/comment_repository.dart';

import 'comment.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentState());

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is LoadingCommentEvent) {
      yield LoadingCommentState();
      try {
        yield await _loadComments(event.index, event.postId);
      } catch (e) {
        yield ErrorCommentState(e.toString());
      }
    }

    if (event is AddCommentEvent) {
      try {
        yield await _addComment(event.comment, event.postId);
      } catch (e) {
        yield ErrorCommentState(e.toString());
      }
    }
  }

  Future<CommentState> _loadComments(int index, int postId) async {
    CommentResponse newState =
        await CommentRepository().getListComments(index, postId);
    return ReceivedCommentState(newState);
  }

  Future<CommentState> _addComment(String comment, int postId) async {
    CommentResponse newState =
        await CommentRepository().addComment(comment, postId);
    return ReceivedCommentState(newState);
  }
}
