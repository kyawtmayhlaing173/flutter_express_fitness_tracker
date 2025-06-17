import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/comment_entity.dart';
import 'package:fitness_tracker_app/domain/repositories/comment_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';

class CreateComment implements UseCase<CommentEntity, CreateCommentParams> {
  final CommentRepository repository;

  CreateComment(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(
      CreateCommentParams params) async {
    return await repository.createComment(
      workoutId: params.workoutId,
      commentText: params.commentText,
    );
  }
}

class CreateCommentParams {
  final String workoutId;
  final String commentText;

  CreateCommentParams({required this.workoutId, required this.commentText});
}
