import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/recipe_model.dart';
import '../../data/repository/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc(this.repository) : super(CommentInitial()) {
    on<FetchComments>((event, emit) async {
      emit(CommentLoading());
      try {
        final comments = await repository.fetchComments(event.recipeId);
        emit(CommentLoaded(comments));
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });

    on<PostComment>((event, emit) async {
      try {
        await repository.postComment(event.recipeId, event.text);
        // Refetch the comments after posting
        final updatedComments = await repository.fetchComments(event.recipeId);
        emit(CommentLoaded(updatedComments));
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
  }
}
