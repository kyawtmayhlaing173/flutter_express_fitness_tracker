import 'package:fitness_tracker_app/domain/entitles/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/workout_provider.dart';

class ScheduleWorkoutPage extends StatefulWidget {
  const ScheduleWorkoutPage({super.key});

  @override
  State<ScheduleWorkoutPage> createState() => _ScheduleWorkoutPageState();
}

class _ScheduleWorkoutPageState extends State<ScheduleWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _exercisesController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  DateTime? _selectedWorkoutDate;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _exercisesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectWorkoutDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedWorkoutDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedWorkoutDate ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedWorkoutDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final workoutProvider =
          Provider.of<WorkoutProvider>(context, listen: false);

      // List<dynamic> exercisesData;
      // try {
      //   exercisesData = json.decode(_exercisesController.text);
      //   // ignore: unnecessary_type_check
      //   if (exercisesData is! List) {
      //     throw const FormatException('Exercises must be a JSON array.');
      //   }
      // } on FormatException catch (e) {
      //   _showSnackBar(
      //       'Error: Invalid exercises JSON format - ${e.message}', Colors.red);
      //   return;
      // }

      await workoutProvider.scheduleWorkoutData(
        name: _nameController.text,
        notes: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        workoutDate: _selectedWorkoutDate!,
        // exercises: exercisesData,
      );

      if (workoutProvider.errorMessage == null) {
        _showSnackBar(
            'Workout scheduled: ${workoutProvider.scheduledWorkout?.name}',
            Colors.green);
        _formKey.currentState!.reset(); // Clear the form
        setState(() {
          _selectedWorkoutDate = null;
        });
      } else {
        _showSnackBar(workoutProvider.errorMessage!, Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Schedule New Workout',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Workout Name',
                    prefixIcon: Icon(Icons.fitness_center),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workout name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectWorkoutDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Workout Date & Time',
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _selectedWorkoutDate == null
                          ? 'Select Date and Time'
                          : DateFormat('yyyy-MM-dd HH:mm')
                              .format(_selectedWorkoutDate!),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (Minutes, Optional)',
                    prefixIcon: Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 1.2,
                        child: const ExerciseSearchPage(),
                      ),
                    );
                  },
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0;
                              i < workoutProvider.selectedExercise.length;
                              i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workoutProvider.selectedExercise[i].name,
                                  ),
                                  Text(
                                    '${workoutProvider.selectedExercise[i].muscleGroup}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Consumer<WorkoutProvider>(
                    builder: (context, workoutProvider, child) {
                      return workoutProvider.isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: const Icon(Icons.add),
                              label: const Text('Schedule Workout'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseSearchPage extends StatefulWidget {
  const ExerciseSearchPage({super.key});

  @override
  State<ExerciseSearchPage> createState() => _ExerciseSearchPageState();
}

class _ExerciseSearchPageState extends State<ExerciseSearchPage> {
  final List<ExerciseEntity> selectedExercises = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutProvider>(context, listen: false).getExerciseList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);
    final exercises = workoutProvider.exercises;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(),
          const SizedBox(height: 16),
          for (var i = 0; i < exercises.length; i++) ...[
            GestureDetector(
              onTap: () {
                workoutProvider.appendExercise(exercises[i]);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: workoutProvider.isSelectedExercise(exercises[i])
                      ? Colors.grey.shade200
                      : Colors.transparent,
                ),
                child: Column(
                  children: [
                    Text('${exercises[i].name} - #${exercises[i].id}'),
                    const SizedBox(height: 8),
                    Text('Difficulty: ${exercises[i].difficulty}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8)
          ],
        ],
      ),
    );
  }
}
