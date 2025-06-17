import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/user_entity.dart';
import '../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  // Future<Either<Failure, UserEntity>> register(String username, String email, String password);
}
