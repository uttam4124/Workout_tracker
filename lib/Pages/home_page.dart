import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/Pages/workout_page.dart';

import '../Components/heat_map.dart';
import '../data/workout_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  final newWorkoutNameController = TextEditingController();
  // create new workout
  void CreateNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Create New Workout'),
                content: TextField(
                  controller: newWorkoutNameController,
                ),
                actions: [
                  MaterialButton(
                    onPressed: save,
                    child: Text('save'),
                  ),
                  MaterialButton(
                    onPressed: cancel,
                    child: Text('cancel'),
                  )
                ]));
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  void save() {
    //adding workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false)
        .addworkout(newWorkoutNameController.text);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: Text('Workout Tracker'),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: CreateNewWorkout, child: const Icon(Icons.add)),
            body: ListView(
              children: [
                //heat map
                MyHeatMap(
                  datasets: value.heatMapDataSet,
                  startDateYYYYMMDD: value.getStartDate(),
                ),
                //WokoutList
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.getWorkoutList().length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(value.getWorkoutList()[index].name),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () => goToWorkoutPage(
                                value.getWorkoutList()[index].name),
                          ),
                        )),
              ],
            )));
  }
}
