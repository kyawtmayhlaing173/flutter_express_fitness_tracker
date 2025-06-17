import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/comment_entity.dart';
import '../../core/error/failures.dart';

abstract class CommentRepository {
  Future<Either<Failure, CommentEntity>> createComment({
    required String workoutId,
    required String commentText,
  });
  // Add other comment-related methods like getCommentsForWorkout, updateComment, deleteComment
}
