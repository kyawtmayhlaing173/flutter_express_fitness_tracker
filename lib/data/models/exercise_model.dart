import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.name,
    super.description,
    super.muscleGroup,
    super.difficulty,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      muscleGroup: json['muscleGroup'] as String?,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscleGroup': muscleGroup,
      'difficulty': difficulty,
    };
  }

  factory ExerciseModel.fromEntity(ExerciseEntity entity) {
    return ExerciseModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      muscleGroup: entity.muscleGroup,
      difficulty: entity.difficulty,
    );
  }
}
