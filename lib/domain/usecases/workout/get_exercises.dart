import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/workout_repository.dart';

class GetExercises implements UseCase<List<ExerciseEntity>, NoParams> {
  final WorkoutRepository repository;

  GetExercises(this.repository);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(NoParams params) async {
    return await repository.getExercises();
  }
}
