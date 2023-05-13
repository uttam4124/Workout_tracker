import 'package:hive/hive.dart';
import 'package:workout_app/Models/exercise.dart';
import 'package:workout_app/data/DateTime/date_time.dart';

import '../Models/workout.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database1");

  // check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("No previous daa exists");
      _myBox.put("START_DATE", todaysDateYYYYYMMDD());
      return false;
    } else {
      print("previous data does exist");
      return true;
    }
  }

  // return start date as yyyymmdd

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout object into lists of strings so that we can save hive dtabase
    final workoutList = convertObjectWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);
    /*
check is any exercises have been completed
we will put a 0 or 1 for each yyyymmdd date

    */
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYYMMDD()}", 0);
    }
    //save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("WORKOUTS", workoutList);
  }

  //save into hive

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");
    //create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have multiple exercises
      List<Exercise> exerisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //so add each exercise in the list
        exerisesInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          sets: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          weight: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
        ));
      }
      //create individual workout
      Workout workout =
          Workout(exercises: exerisesInEachWorkout, name: workoutNames[i]);
      //add individual workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  // check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    //go thru each workout
    for (var workout in workouts) {
      //go thru each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
//returns 0 or 1 if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

// converts workout objects into a list
List<String> convertObjectWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

// converts the exercises in a workout object into a list of strings

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    // [

//  Upper Body
//  [ [biceps, 18kg, 10reps, 3sets], [triceps, 20kg, 10reps, 3sets] ],
//
//  Lower Body
//
//  [[squats, 25kg, 10reps, 3sets], (legraise, 30kg, 10reps, 3sets], [calf, 10kg, 10reps, 3sets]]
//
// ]
  ];
  //go through EACH workout
  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [
      //UpperBody
      //[[biceps,10kg,10reps,3sets],[triceps,20kg,10reps,3sets]],
    ];
    //go through each exercise in exerciselist
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        //[biceps,10kg,10reps,3sets]
      ];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
