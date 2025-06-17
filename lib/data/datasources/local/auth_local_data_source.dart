// This would typically use shared_preferences or flutter_secure_storage
// For simplicity, we'll use a in-memory store for this example.
// In a real app, use a persistent and secure storage.

import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> deleteAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _preferences;
  AuthLocalDataSourceImpl(this._preferences);

  @override
  Future<void> deleteAuthToken() async {
    await _preferences.remove('auth_token');
  }

  @override
  Future<String?> getAuthToken() async {
    return _preferences.getString('auth_token');
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await _preferences.setString('auth_token', token);
  }
}
