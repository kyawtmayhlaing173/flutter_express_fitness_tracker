import 'package:fitness_tracker_app/domain/entitles/user_entity.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/auth/login_user.dart';
import '../../core/network/app_http_client.dart'; // Import AppHttpClient

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _authToken;

  final AppHttpClient _apiService = AppHttpClient();

  AuthProvider({required this.loginUser});

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get authToken => _authToken;
  AppHttpClient get apiService => _apiService;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result =
        await loginUser(LoginParams(email: email, password: password));

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
      },
      (user) {
        _currentUser = user;
        _authToken = user.authToken;
        _isLoading = false;
      },
    );
    notifyListeners();
    return _currentUser != null;
  }

  void logout() {
    _currentUser = null;
    _authToken = null;
    _isLoading = false;
    _errorMessage = null;
    // In a real app, also delete the token from local storage
    notifyListeners();
  }
}
