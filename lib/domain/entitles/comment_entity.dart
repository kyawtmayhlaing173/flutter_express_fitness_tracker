import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String userId;
  final String workoutId;
  final String commentText;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.commentText,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, workoutId, commentText, createdAt];
}
