import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/Components/exercise_tile.dart';
import 'package:workout_app/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

// create new exercise
  void createnewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add a new exercise'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
//exercise name
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Name of Exercise'),
                  controller: exerciseNameController,
                ),
// weight
                TextField(
                  decoration: const InputDecoration(hintText: 'weight'),
                  controller: weightController,
                ),
//reps
                TextField(
                  decoration: const InputDecoration(hintText: 'reps'),
                  controller: repsController,
                ),
//sets
                TextField(
                  decoration: const InputDecoration(hintText: 'sets'),
                  controller: setsController,
                )
              ]),
              actions: [
                //save
                MaterialButton(onPressed: save, child: Text('save')),

                //cancel
                MaterialButton(
                  onPressed: cancel,
                  child: Text('cancel'),
                )
              ],
            ));
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    //get exercise name from text controller

    //add exercise to workout list
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: () => createnewExercise(),
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.numberOfexerciseInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
                exerciseName: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onChanged: (val) => onChanged(
                      widget.workoutName,
                      value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name,
                    ),
                reps: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .reps,
                sets: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .sets,
                weight: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .weight)),
      ),
    );
  }
}
