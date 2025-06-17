import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/workout_repository.dart';

class GetWorkouts implements UseCase<List<WorkoutEntity>, GetWorkoutsParams> {
  final WorkoutRepository repository;

  GetWorkouts(this.repository);

  @override
  Future<Either<Failure, List<WorkoutEntity>>> call(
      GetWorkoutsParams params) async {
    return await repository.getWorkouts(
      status: params.status,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

class GetWorkoutsParams {
  final String? status;
  final String? sortBy;
  final String? sortOrder;

  GetWorkoutsParams({
    this.status,
    this.sortBy,
    this.sortOrder,
  });
}
