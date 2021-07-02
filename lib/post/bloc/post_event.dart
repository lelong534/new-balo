part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadingPostEvent extends PostEvent {
  final index;
  final count;

  LoadingPostEvent({this.index, this.count});
}

class LoadingMorePostEvent extends PostEvent {
  final index;
  final count;

  LoadingMorePostEvent({this.index, this.count});
}

class LikePostEvent extends PostEvent {
  final Post post;
  LikePostEvent(this.post);
}

class UnLikePostEvent extends PostEvent {
  final Post post;
  UnLikePostEvent(this.post);
}

class AddPostEvent extends PostEvent {
  final List<MultipartFile>? images;
  final String description;

  AddPostEvent({
    this.images,
    required this.description,
  });
}

class AddPostVideoEvent extends PostEvent {
  final File? video;
  final String description;

  AddPostVideoEvent({
    this.video,
    required this.description,
  });
}

class LoadingPostByUserEvent extends PostEvent {
  final index;
  final count;
  final int userId;

  LoadingPostByUserEvent({
    this.index,
    this.count,
    required this.userId,
  });
}
