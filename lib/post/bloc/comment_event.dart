abstract class CommentEvent {}

class LoadingCommentEvent extends CommentEvent {
  final int index;
  final int postId;

  LoadingCommentEvent({required this.index, required this.postId});

  @override
  String toString() => 'Load comments';
}

class AddCommentEvent extends CommentEvent {
  final String comment;
  final int postId;

  AddCommentEvent({required this.comment, required this.postId});

  @override
  String toString() => 'Add comment';
}
