part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchComments extends CommentEvent {
  final String recipeId;

  FetchComments(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class PostComment extends CommentEvent {
  final String recipeId;
  final String text;

  PostComment(this.recipeId, this.text);

  @override
  List<Object?> get props => [recipeId, text];
}
