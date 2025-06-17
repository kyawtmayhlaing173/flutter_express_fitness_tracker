import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../error/exceptions.dart';
import '../common/constants.dart'; // For API URL

class AppHttpClient {
  final http.Client _client = http.Client();
  final String _baseUrl =
      dotenv.env[AppConstants.baseUrlEnvKey] ?? AppConstants.defaultBaseUrl;

  Future<Map<String, dynamic>> get(String path,
      {String? authToken, Map<String, String>? queryParams}) async {
    final uri =
        Uri.parse('$_baseUrl$path').replace(queryParameters: queryParams);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response = await _client.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body,
      {String? authToken}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response =
        await _client.post(uri, headers: headers, body: json.encode(body));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body,
      {String? authToken}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final response =
        await _client.patch(uri, headers: headers, body: json.encode(body));
    return _handleResponse(response);
  }

  // You can add put, delete methods here as needed

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw ServerException(
          errorData['message'] ?? 'An unknown error occurred.',
          statusCode: response.statusCode);
    }
  }
}
