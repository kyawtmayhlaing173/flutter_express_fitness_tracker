import 'package:fitness_tracker_app/domain/entitles/workout_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutListItem extends StatelessWidget {
  final WorkoutEntity workout;

  const WorkoutListItem({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          workout.name,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(workout.notes),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(workout.workoutDate)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${workout.status}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Exercises: ${workout.exercises.length} items',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Tapped Workout: ${workout.name} (ID: ${workout.id})'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }
}
