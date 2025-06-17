import '../../../core/error/exceptions.dart';
import '../../../core/network/app_http_client.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  // Future<UserModel> register(String username, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppHttpClient httpClient;

  AuthRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        '/user/login',
        {'email': email, 'password': password},
      );
      if (response.containsKey('user') && response.containsKey('token')) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>)
            .copyWith(
          authToken: response['token'] as String,
        );
      } else {
        throw const ServerException('Login response malformed.');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to connect to login server: $e');
    }
  }
}

// Extend UserModel to add a copyWith for authToken, as Entity doesn't have it explicitly
extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? authToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      authToken: authToken ?? this.authToken,
    );
  }
}
