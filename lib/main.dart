import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/screens/new_task_screen.dart';
import 'package:todolist/screens/routing.dart';
import 'package:todolist/sqlite.dart';
import 'package:todolist/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqliteDB.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    sqliteDB.getAllPendingTasks();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: MyHomePage(),
        /*routes: {
          newTaskScreenID: (context) {
            return const NewTaskScren();
          },
          homescreen: (context) {
            return const MyHomePage();
          },
        },*/
        onGenerateRoute: (settings) {
          var pageName = settings.name;
          var args = settings.arguments;
          if (pageName == newTaskScreenID) {
            if (args is Task) {
              print(args);
              return MaterialPageRoute(
                  builder: (context) => NewTaskScren(task: args));
            }
            print("hi");
            return MaterialPageRoute(builder: (context) => NewTaskScren());
          }
          if (pageName == homescreen) {
            return MaterialPageRoute(builder: (context) => MyHomePage());
          }
        });
  }
}
