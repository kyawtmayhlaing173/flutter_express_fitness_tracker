import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';
import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/remote/workout_remote_data_source.dart';
import '../datasources/local/auth_local_data_source.dart'; // To get auth token

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource workoutRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  WorkoutRepositoryImpl({
    required this.workoutRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, WorkoutEntity>> scheduleWorkout({
    required String name,
    String? notes,
    required DateTime workoutDate,
    required List<ExerciseEntity> exercises,
  }) async {
    try {
      final authToken = await authLocalDataSource.getAuthToken();
      if (authToken == null) {
        return const Left(
            AuthFailure('No authentication token found. Please log in.'));
      }
      final exerciseJson = exercises
          .map(
            (exercise) => {
              "exerciseId": exercise.id,
              "sets": 0,
              "reps": 0,
              "duration": 0,
            },
          )
          .toList();
      log('Exercise Json $exerciseJson');
      final workoutModel = await workoutRemoteDataSource.scheduleWorkout(
        name: name,
        notes: notes,
        workoutDate: workoutDate,
        exercises: exerciseJson,
        authToken: authToken,
      );
      return Right(workoutModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      log('Error is ${e.toString()}');
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutEntity>>> getWorkouts({
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final authToken = await authLocalDataSource.getAuthToken();
      log('Auth Token $authToken');
      if (authToken == null) {
        return const Left(
            AuthFailure('No authentication token found. Please log in.'));
      }
      final workoutModels = await workoutRemoteDataSource.getWorkouts(
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
        authToken: authToken,
      );
      return Right(workoutModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercises() async {
    try {
      final authToken = await authLocalDataSource.getAuthToken();
      log('Auth Token $authToken');
      if (authToken == null) {
        return const Left(
            AuthFailure('No authentication token found. Please log in.'));
      }
      final exercises =
          await workoutRemoteDataSource.getExercises(authToken: authToken);
      return Right(exercises);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
