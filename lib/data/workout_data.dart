import 'package:flutter/material.dart';
import 'package:workout_app/Models/exercise.dart';
import 'package:workout_app/Models/workout.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/data/DateTime/date_time.dart';

import 'hive_database.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  // workout datastructure
  //  this overall list contains the different workouts
  // each workout has a name,and list of exercises

  List<Workout> workoutList = [
    Workout(name: "Upper Body", exercises: [
      Exercise(
          weight: "10",
          name: "bicep curls",
          reps: "10",
          sets: "3",
          isCompleted: false)
    ]),
    Workout(name: "Lower Body", exercises: [
      Exercise(
          weight: "10",
          name: "bicep curls",
          reps: "10",
          sets: "3",
          isCompleted: false)
    ])
  ];
  // if there are workouts already in database then gets that workout list otherwise use defalut workout list
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
    //load HeatMap
    loadHeatMap();
  }

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // add a workout
  void addworkout(String name) {
    //add a new workout with a blank list f exercises

    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  // add an exercise
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(Exercise(
        name: exerciseName,
        sets: sets,
        reps: reps,
        weight: weight,
        isCompleted: false));
    notifyListeners();
  }

// check off exercises
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

// get length of a given workout
  int numberOfexerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  // return relevantWorkout,object,given a workout name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    // find relevant exercise
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());
    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start date to today and add each completion status to the dataset
    //"COMPLETION_STATUS_YYYYMMDD" WILL BE THE the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      //completion status=0or1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;
      // month
      int month = startDate.add(Duration(days: i)).month;
      //days
      int day = startDate.add(Duration(days: i)).day;
      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      //add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
