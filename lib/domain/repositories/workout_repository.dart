import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';
import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';
import '../../core/error/failures.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, WorkoutEntity>> scheduleWorkout({
    required String name,
    String? notes,
    required DateTime workoutDate,
    required List<ExerciseEntity> exercises,
  });

  Future<Either<Failure, List<WorkoutEntity>>> getWorkouts({
    String? status,
    String? sortBy,
    String? sortOrder,
  });

  Future<Either<Failure, List<ExerciseEntity>>> getExercises();

  // Add more methods for update, delete, get single workout etc.
}
