import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'like_repository.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRepository likeRepository;

  LikeBloc({required this.likeRepository}) : super(LikeInitial()) {
    on<FetchLikeStatus>(_onFetchLikeStatus);
    on<ToggleLike>(_onToggleLike);
  }

  Future<void> _onFetchLikeStatus(
      FetchLikeStatus event, Emitter<LikeState> emit) async {
    try {
      emit(LikeLoading());

      final isLiked = await likeRepository.isLiked(event.recipeId);
      final likeCount = await likeRepository.likeCount(event.recipeId);

      emit(LikeSuccess(isLiked: isLiked, likeCount: likeCount));
    } catch (e) {
      emit(LikeError('Failed to fetch like status: $e'));
    }
  }

  Future<void> _onToggleLike(ToggleLike event, Emitter<LikeState> emit) async {
    try {
      emit(LikeLoading());

      await likeRepository.toggleLike(event.recipeId);

      final isLiked = await likeRepository.isLiked(event.recipeId);
      final likeCount = await likeRepository.likeCount(event.recipeId);

      emit(LikeSuccess(isLiked: isLiked, likeCount: likeCount));
    } catch (e) {
      emit(LikeError('Failed to toggle like: $e'));
    }
  }
}
