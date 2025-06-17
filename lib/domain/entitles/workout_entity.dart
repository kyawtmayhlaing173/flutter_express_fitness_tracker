import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String status;
  final List<dynamic> exercises;
  final DateTime workoutDate;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    required this.exercises,
    required this.workoutDate,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        status,
        exercises,
        workoutDate,
        notes,
        createdAt,
        updatedAt,
      ];
}
