import 'package:fitness_tracker_app/presentation/pages/workout/schedule_workout_page.dart';
import 'package:fitness_tracker_app/presentation/pages/workout/workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fitness Tracker'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                authProvider.logout();
                // The Consumer in main.dart will automatically navigate to LoginPage
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add_task), text: 'Schedule'),
              Tab(icon: Icon(Icons.list), text: 'My Workouts'),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    ScheduleWorkoutPage(),
                    WorkoutListPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
