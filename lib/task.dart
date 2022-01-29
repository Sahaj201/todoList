enum RepeatCycle {
  noRepeat,
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

class Task {
  Task(
      {required this.taskName,
        required this.id,
        this.parentTaskID,
        this.date,
        this.time,
        required this.finished,
        required this.skipped}) {
      if (date == null) {
    // assert gives error when this condition is false
    assert(time==null)
        }
  }
  String id;
  String? parentTaskID; //used for repeated task instances onlt
  String taskName;
  DateTime? date;
  DateTime? time;
  bool finished;
  bool skipped;
}

class RepeatedTask {
  String repeatingTaskID;
  String repeatingTaskName;
  RepeatCycle? repeatCycle;
  RepeatFrequency? repeatFrequency;
  DateTime deadlineDate;
  DateTime? deadlineTime;

  RepeatedTask({required this.repeatingTaskID,
    required this.repeatingTaskName,
    required this.repeatCycle,
    this.repeatFrequency,
    required this.deadlineDate,
    this.deadlineTime});
}

class TaskList{
  String taskListId;
  String taskListName;
  List<Task> nonRepeatingTasks=[];
  List<RepeatedTask> repeatingTasks=[];
  List<Task> repeatingTaskInstances=[];

  TaskList({
    required this.nonRepeatingTasks,
    required this.repeatingTasks,
    required this.repeatingTaskInstances
});

}

