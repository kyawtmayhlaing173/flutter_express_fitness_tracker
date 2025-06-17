import 'package:fitness_tracker_app/core/usecases/usecase.dart';
import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';
import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';
import 'package:fitness_tracker_app/domain/usecases/workout/get_exercises.dart';
import 'package:fitness_tracker_app/domain/usecases/workout/get_workouts.dart';
import 'package:fitness_tracker_app/domain/usecases/workout/schedule_workout.dart';
import 'package:flutter/material.dart';

class WorkoutProvider with ChangeNotifier {
  final ScheduleWorkout scheduleWorkout;
  final GetWorkouts getWorkouts;
  final GetExercises getExercises;

  WorkoutProvider({
    required this.scheduleWorkout,
    required this.getWorkouts,
    required this.getExercises,
    String? authToken,
  }) : _authToken = authToken;

  WorkoutEntity? _scheduledWorkout;
  List<WorkoutEntity> _workouts = [];
  List<ExerciseEntity> _exercises = [];
  List<ExerciseEntity> _selectedExercises = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _authToken;

  WorkoutEntity? get scheduledWorkout => _scheduledWorkout;
  List<WorkoutEntity> get workouts => _workouts;
  List<ExerciseEntity> get exercises => _exercises;
  List<ExerciseEntity> get selectedExercise => _selectedExercises;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set authToken(String? token) {
    if (_authToken != token) {
      _authToken = token;
    }
  }

  Future<void> scheduleWorkoutData({
    required String name,
    String? notes,
    required DateTime workoutDate,
    // required List<dynamic> exercises,
  }) async {
    if (_authToken == null) {
      _errorMessage = 'Authentication token is missing. Please log in.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await scheduleWorkout(
      ScheduleWorkoutParams(
        name: name,
        notes: notes,
        workoutDate: workoutDate,
        exercises: _selectedExercises,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (workout) {
        _scheduledWorkout = workout;
        _workouts.insert(0, workout);
        _workouts.sort((a, b) => b.workoutDate.compareTo(a.workoutDate));
        _selectedExercises = [];
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getWorkoutList({
    String? status,
    String? sortBy = 'workoutDate',
    String? sortOrder = 'desc',
  }) async {
    if (_authToken == null) {
      _errorMessage = 'Authentication token is missing. Please log in.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getWorkouts(
      GetWorkoutsParams(
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (workoutsList) {
        _workouts = workoutsList;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getExerciseList() async {
    if (_authToken == null) {
      _errorMessage = 'Authentication token is missing. Please log in.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getExercises(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (exerciseList) {
        _exercises = exerciseList;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  void appendExercise(ExerciseEntity exercise) {
    _selectedExercises.add(exercise);
    notifyListeners();
  }

  bool isSelectedExercise(ExerciseEntity selectedExercise) {
    final exercises = _selectedExercises
        .where((exercise) => exercise.id == selectedExercise.id)
        .toList();
    return exercises.isNotEmpty;
  }
}
