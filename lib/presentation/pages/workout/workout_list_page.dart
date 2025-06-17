import 'package:fitness_tracker_app/presentation/widgets/workout/workout_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutProvider>(context, listen: false).getWorkoutList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        if (workoutProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (workoutProvider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${workoutProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => workoutProvider.getWorkoutList(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (workoutProvider.workouts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sentiment_dissatisfied,
                    size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No workouts found. Try scheduling one!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => workoutProvider.getWorkoutList(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              workoutProvider.getWorkouts;
            },
            child: ListView.builder(
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return WorkoutListItem(workout: workout);
              },
            ),
          );
        }
      },
    );
  }
}
