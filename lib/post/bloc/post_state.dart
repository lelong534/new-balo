part of 'post_bloc.dart';

class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class LoadingPostState extends PostState {
  @override
  List<Object> get props => [toString()];

  @override
  String toString() => 'Loading';
}

class ReceivedPostState extends PostState {
  final PostResponse posts;

  ReceivedPostState(this.posts);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'Received Post';
}

class HidePostSuccessState extends PostState {
  final PostResponse posts;

  HidePostSuccessState(this.posts);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'Hided Post';
}

class AddPostSuccessState extends PostState {
  final PostResponse posts;

  AddPostSuccessState(this.posts);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'Add Post';
}

class BlockUserSuccessState extends PostState {
  final PostResponse posts;

  BlockUserSuccessState(this.posts);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'Hided Post';
}

class ErrorPostState extends PostState {
  final String errorMessage;

  ErrorPostState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'Error: ' + errorMessage;
}
