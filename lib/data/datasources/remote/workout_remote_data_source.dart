import 'dart:developer';

import 'package:fitness_tracker_app/data/models/exercise_model.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/network/app_http_client.dart';
import '../../models/workout_model.dart';

abstract class WorkoutRemoteDataSource {
  Future<WorkoutModel> scheduleWorkout({
    required String name,
    String? notes,
    required DateTime workoutDate,
    required List<dynamic> exercises,
    required String authToken,
  });

  Future<List<WorkoutModel>> getWorkouts({
    String? status,
    String? sortBy,
    String? sortOrder,
    required String authToken,
  });

  Future<List<ExerciseModel>> getExercises({
    required String authToken,
  });
}

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final AppHttpClient httpClient;

  WorkoutRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<WorkoutModel> scheduleWorkout({
    required String name,
    String? notes,
    required DateTime workoutDate,
    required List<dynamic> exercises,
    required String authToken,
  }) async {
    try {
      log('Workout Date ${workoutDate.toIso8601String()}Z');
      final response = await httpClient.post(
        '/workout',
        {
          'name': name,
          'notes': notes,
          'workoutDate': '${workoutDate.toIso8601String()}Z',
          'exercises': exercises,
        },
        authToken: authToken,
      );
      log('Schedule data is $response');
      return WorkoutModel.fromJson(response['workout'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to schedule workout: $e');
    }
  }

  @override
  Future<List<WorkoutModel>> getWorkouts({
    String? status,
    String? sortBy,
    String? sortOrder,
    required String authToken,
  }) async {
    try {
      // final Map<String, String> queryParams = {};
      // if (status != null && status.isNotEmpty) queryParams['status'] = status;
      // if (sortBy != null && sortBy.isNotEmpty) queryParams['sortBy'] = sortBy;
      // if (sortOrder != null && sortOrder.isNotEmpty) {
      // queryParams['sortOrder'] = sortOrder;
      // }

      final response = await httpClient.get(
        '/workout',
        authToken: authToken,
        // queryParams: queryParams,
      );
      final data = response['data'];
      final workoutsJson = data as List<dynamic>;

      return workoutsJson.map((json) => WorkoutModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get workouts: $e');
    }
  }

  @override
  Future<List<ExerciseModel>> getExercises({
    required String authToken,
  }) async {
    try {
      final response = await httpClient.get('/exercise', authToken: authToken);
      final data = response['data'];
      final exerciseJson = data as List<dynamic>;

      return exerciseJson.map((json) => ExerciseModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get workouts: $e');
    }
  }
}
