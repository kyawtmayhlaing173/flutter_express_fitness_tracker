import 'package:fitness_tracker_app/data/datasources/local/auth_local_data_source.dart';
import 'package:fitness_tracker_app/domain/usecases/workout/get_exercises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/common/constants.dart';
import 'core/network/app_http_client.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/datasources/remote/workout_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/workout_repository_impl.dart';
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/workout/get_workouts.dart';
import 'domain/usecases/workout/schedule_workout.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/workout_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({required this.sharedPreferences, super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize core services
    final AppHttpClient httpClient = AppHttpClient();

    final AuthRemoteDataSource authRemoteDataSource =
        AuthRemoteDataSourceImpl(httpClient: httpClient);

    final WorkoutRemoteDataSource workoutRemoteDataSource =
        WorkoutRemoteDataSourceImpl(httpClient: httpClient);

    final AuthLocalDataSource authLocalDataSource =
        AuthLocalDataSourceImpl(sharedPreferences);

    // Initialize repositories
    final AuthRepositoryImpl authRepository = AuthRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
      authLocalDataSource: authLocalDataSource,
    );
    final WorkoutRepositoryImpl workoutRepository = WorkoutRepositoryImpl(
      workoutRemoteDataSource: workoutRemoteDataSource,
      authLocalDataSource: authLocalDataSource,
    );

    // Initialize use cases
    final LoginUser loginUser = LoginUser(authRepository);
    final ScheduleWorkout scheduleWorkout = ScheduleWorkout(workoutRepository);
    final GetWorkouts getWorkouts = GetWorkouts(workoutRepository);
    final GetExercises getExercises = GetExercises(workoutRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUser: loginUser),
        ),
        ChangeNotifierProxyProvider<AuthProvider, WorkoutProvider>(
          create: (context) => WorkoutProvider(
            scheduleWorkout: scheduleWorkout,
            getWorkouts: getWorkouts,
            getExercises: getExercises,
            authToken: context.read<AuthProvider>().authToken,
          ),
          update: (context, authProvider, workoutProvider) {
            if (workoutProvider == null) {
              return WorkoutProvider(
                getWorkouts: getWorkouts,
                getExercises: getExercises,
                authToken: authProvider.authToken,
                scheduleWorkout: scheduleWorkout,
              );
            }
            workoutProvider.authToken = authProvider.authToken;
            return workoutProvider;
          },
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
          brightness: Brightness.light,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Inter'),
            labelLarge: TextStyle(fontFamily: 'Inter'),
            headlineSmall: TextStyle(fontFamily: 'Inter'),
            titleMedium: TextStyle(fontFamily: 'Inter'),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Inter'),
            labelLarge: TextStyle(fontFamily: 'Inter'),
            headlineSmall: TextStyle(fontFamily: 'Inter'),
            titleMedium: TextStyle(fontFamily: 'Inter'),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.authToken != null &&
                authProvider.authToken!.isNotEmpty) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
