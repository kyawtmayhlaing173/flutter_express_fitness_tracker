class AppConstants {
  static const String appName = 'Fitness Tracker';

  // Environment variable keys
  static const String baseUrlEnvKey = 'BASE_URL';
  static const String jwtSecretEnvKey = 'JWT_SECRET';

  // Default values (useful for development if .env is missing or local testing)
  static const String defaultBaseUrl = 'http://localhost:3000';
  static const String defaultJwtSecret =
      'your_jwt_secret_fallback'; // Replace with a strong default for dev
}
