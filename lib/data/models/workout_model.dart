import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({
    required super.id,
    required super.name,
    required super.userId,
    required super.status,
    required super.exercises,
    required super.workoutDate,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      exercises: json['exercises'] as List<dynamic>,
      workoutDate: DateTime.parse(json['workoutDate'] as String),
      notes: json['notes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'status': status,
      'exercises': exercises.map((e) => (e as WorkoutModel).toJson()).toList(),
      'workoutDate': workoutDate.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WorkoutModel.fromEntity(WorkoutEntity entity) {
    return WorkoutModel(
      id: entity.id,
      name: entity.name,
      userId: entity.userId,
      status: entity.status,
      exercises: entity.exercises,
      workoutDate: entity.workoutDate,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
