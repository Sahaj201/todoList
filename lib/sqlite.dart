import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task.dart';

class sqliteDB {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  //Initialize DB
  static initDb() async {
    String folderPath = await getDatabasesPath();
    String path = join(folderPath, "todo.db");
    //await deleteDatabase(path);
    var taskDb = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int t) async {
        await db.execute(
            'CREATE TABLE TASK (taskID INTEGER PRIMARY KEY, taskListID INTEGER, parentTaskID INTEGER, taskName TEXT, deadlineDate INTEGER, deadlineTime INTEGER, isFinished INTEGER, isRepeating INTEGER)');
      },
    );
    _db = taskDb;
    return taskDb;
  }

  static Future<int?> insertTask(Map<String, dynamic> taskdata) async {
    print(db);
    var dbClient = await db;

    int id = await dbClient.insert("TASK", taskdata);
    if (id != 0) {
      return id;
    } else {
      return (null);
    }
  }

  static Future<List<Task>> getAllPendingTasks() async {
    var dbClient = await db;
    List<Map<String, dynamic>> taskListFromDB =
        await dbClient.query("TASK", where: "isFinished=0");
    List<Task> taskListAsObjects = [];
    for (var map in taskListFromDB) {
      taskListAsObjects.add(Task.fromMap(map));
    }
    return (taskListAsObjects);
    //var taskListMemory = taskListFromDB.map((t) => Task.fromMap(t)).toList();
    // return(taskListMemory);//
  }

  static Future<bool> updateTask(Task task) async {
    var dbClient = await db;
    int changes = await dbClient.update("TASK", task.toMap(),
        where: "taskID=?",
        whereArgs: [task.taskID]); //? replace with task.taskID
    return (changes > 0);
  }

  static Future<bool> deleteTask(Task task) async {
    var dbClient = await db;
    int changes = await dbClient.delete("TASK",
        where: "taskID=?",
        whereArgs: [task.taskID]); //? replace with task.taskID
    return (changes == 1);
  }
}
