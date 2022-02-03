import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RepeatCycle {
  onceADay,
  onceADayMonFri,
  onceAWeek,
  onceAMonth,
  onceAYear,
  other
}
enum Tenure { days, weeks, months }

class RepeatFrequency {
  RepeatFrequency({required this.num, required this.tenure});
  int num;
  Tenure tenure;
}

int intFromTimeOfDay(TimeOfDay tod) {
  return (tod.minute + 60 * tod.hour);
}

TimeOfDay timeOfDayFromInt(int todInt) {
  return TimeOfDay(hour: todInt ~/ 60, minute: todInt % 60);
}

class Task {
  static late int counter;

  Task({
    required this.taskListID,
    required this.taskName,
    required this.taskID,
    required this.isRepeating,
    this.parentTaskID,
    this.deadlineDate,
    this.deadlineTime,
    required this.isFinished,
  });

  late int taskID;
  int taskListID;
  int? parentTaskID; //used for repeated task instances onlt
  String taskName;
  DateTime? deadlineDate;
  TimeOfDay? deadlineTime;
  bool isFinished;
  bool isRepeating;

  void finishedTask() {
    isFinished = true;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> taskAsMap = {
      "taskID": taskID,
      "taskListID": taskListID,
      "parentTaskID": null,
      "taskName": taskName,
      "deadlineDate":
          deadlineDate == null ? null : deadlineDate!.millisecondsSinceEpoch,
      "deadlineTime":
          deadlineTime == null ? null : intFromTimeOfDay(deadlineTime!),
      "isFinished": isFinished == true ? 1 : 0,
      "isRepeating": isRepeating == true ? 1 : 0,
    };
    return (taskAsMap);
  }

  static Task fromMap(Map<String, dynamic> taskAsMap) {
    Task task = Task(
      taskID: taskAsMap["taskID"],
      taskListID: taskAsMap["taskListID"],
      parentTaskID: taskAsMap["parentTaskID"],
      taskName: taskAsMap["taskName"],
      deadlineDate: taskAsMap["deadlineDate"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(taskAsMap["deadlineDate"]),
      deadlineTime: taskAsMap["deadlineTime"] == null
          ? null
          : timeOfDayFromInt(taskAsMap["deadlineTime"]),
      isFinished: taskAsMap["isFinished"] == 0 ? false : true,
      isRepeating: taskAsMap["isRepeating"] == 0 ? false : true,
    );
    return (task);
  }
}

class RepeatingTask {
  int repeatingTaskID;
  int taskListId;
  String repeatingTaskName;
  RepeatCycle? repeatCycle;
  RepeatFrequency? repeatFrequency;
  DateTime deadlineDate;
  DateTime? deadlineTime;

  RepeatingTask(
      {required this.repeatingTaskID,
      required this.repeatingTaskName,
      required this.repeatCycle,
      this.repeatFrequency,
      required this.deadlineDate,
      this.deadlineTime,
      required this.taskListId});
}

class TaskList {
  int taskListId;
  String taskListName;
  List<Task> nonRepeatingTasks;
  List<RepeatingTask> repeatingTasks;
  List<Task> activerepeatingTaskInstances;

  TaskList(
      {required this.nonRepeatingTasks,
      required this.repeatingTasks,
      required this.activerepeatingTaskInstances,
      required this.taskListId,
      required this.taskListName});

  List<Task> getActiveTasks() {
    List<Task> activeNonRepeatingTasks = [];
    {
      for (var i = 0; i < nonRepeatingTasks.length; i++)
        if (nonRepeatingTasks[i].isFinished == false) {
          activeNonRepeatingTasks.add(nonRepeatingTasks[i]);
        }
      return (activeNonRepeatingTasks);
    }
  }

  List<Task> getFinishedTasks() {
    return ([]);
  }

  void FinishTask(Task task) {}

  void addTask(
      {required int taskId,
      required bool isRepeating,
      required String taskName,
      DateTime? deadlineDate = null,
      TimeOfDay? deadlineTime = null,
      int? parentTaskID}) {
    Task(
      taskName: taskName,
      taskListID: taskListId,
      isFinished: false,
      deadlineDate: deadlineDate,
      deadlineTime: deadlineTime,
      parentTaskID: parentTaskID,
      taskID: taskId,
      isRepeating: isRepeating,
    );
    /*if (parentTaskID!=null)
      {
        activerepeatingTaskInstances
      }
      }
      void finishTask( Task task){

      }*/
  }
}
