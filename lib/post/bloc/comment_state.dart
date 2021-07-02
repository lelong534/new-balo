import 'package:equatable/equatable.dart';
import 'package:flutter_zalo_bloc/post/models/comment_response.dart';

class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class InitialCommentState extends CommentState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Initial';
}

class ReceivedCommentState extends CommentState {
  final CommentResponse comments;

  ReceivedCommentState(this.comments);

  @override
  List<Object> get props => [comments];

  @override
  String toString() => 'Received Comment';
}

class ErrorCommentState extends CommentState {
  final String errorMessage;

  ErrorCommentState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Error: ' + errorMessage;
}

class LoadingCommentState extends CommentState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Loading';
}
