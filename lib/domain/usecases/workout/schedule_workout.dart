import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';
import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/workout_repository.dart';

class ScheduleWorkout implements UseCase<WorkoutEntity, ScheduleWorkoutParams> {
  final WorkoutRepository repository;

  ScheduleWorkout(this.repository);

  @override
  Future<Either<Failure, WorkoutEntity>> call(
      ScheduleWorkoutParams params) async {
    return await repository.scheduleWorkout(
      name: params.name,
      notes: params.notes,
      workoutDate: params.workoutDate,
      exercises: params.exercises,
    );
  }
}

class ScheduleWorkoutParams {
  final String name;
  final String? notes;
  final DateTime workoutDate;
  final List<ExerciseEntity> exercises;

  ScheduleWorkoutParams({
    required this.name,
    this.notes,
    required this.workoutDate,
    required this.exercises,
  });
}
