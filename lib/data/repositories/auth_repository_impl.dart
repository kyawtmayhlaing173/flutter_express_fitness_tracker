import 'package:dartz/dartz.dart';
import 'package:fitness_tracker_app/domain/entitles/user_entity.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../datasources/local/auth_local_data_source.dart'; // Import local data source

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final userModel = await authRemoteDataSource.login(email, password);
      if (userModel.authToken != null) {
        await authLocalDataSource.saveAuthToken(userModel.authToken!);
      }
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
