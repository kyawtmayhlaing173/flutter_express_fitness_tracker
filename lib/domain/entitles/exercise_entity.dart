import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? muscleGroup;
  final String? difficulty;

  const ExerciseEntity({
    required this.id,
    required this.name,
    this.description,
    this.muscleGroup,
    this.difficulty,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        muscleGroup,
        difficulty,
      ];
}
