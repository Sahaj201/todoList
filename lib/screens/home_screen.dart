import 'package:todolist/main.dart';
import 'package:flutter/material.dart';
import 'package:todolist/sqlite.dart';
import '../task.dart';
import 'routing.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Task>> taskList = sqliteDB.getAllPendingTasks();
  Widget futureBuilderProvider() {
    return (FutureBuilder<List<Task>>(
        future: taskList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Container(child: Text("I have Data"));
          } else {
            Container(child: Text("Some Error"));
          }
          return Container();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 35),
          onPressed: () {
            /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const NewTaskScren();
            }),
          );*/
            Navigator.pushNamed(context, newTaskScreenID); //Named Routes
          },
        ),
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text("Todo"),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder<List<Task>>(
            future: taskList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                List<Widget> children = [];
                for (var task in data) {
                  children.add(ActivityCard(
                    header: task.taskName,
                    date: task.deadlineDate == null
                        ? ""
                        : task.deadlineDate.toString(),
                    list: task.taskListID.toString(),
                    onTap: () {
                      Navigator.pushNamed(context, newTaskScreenID,
                          arguments: task);
                    },
                    task: task,
                  ));
                }
                return ListView(
                  padding: EdgeInsets.all(5),
                  children: children,
                );
              } else if (snapshot.hasError) {
                return (Text("Some Error"));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })
        /*ListView(padding: EdgeInsets.all(5), children: [
          ActivityCard("Pay bil", "4th July", "Pay bills"),
          ActivityCard("Pay fee", "5th July", "Pay bills"),
          ActivityCard("Pay rent", "6th July", "Pay bills"),
          ActivityCard("Pay bil", "4th July", "Pay bills"),
          ActivityCard("Pay fee", "5th July", "Pay bills"),
          ActivityCard("Pay rent", "6th July", "Pay bills"),
          ActivityCard("Pay bil", "4th July", "Pay bills"),
          ActivityCard("Pay fee", "5th July", "Pay bills"),
          ActivityCard("Pay rent", "6th July", "Pay bills"),
          ActivityCard("Pay bil", "4th July", "Pay bills"),
          ActivityCard("Pay fee", "5th July", "Pay bills"),
          ActivityCard("Pay rent", "6th July", "Pay bills"),
        ]),*/
        );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    required this.header,
    required this.task,
    required this.date,
    required this.list,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String header;
  final String date;
  final String list;

  final void Function() onTap;
  final Task task;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10.5, 0, 0),
                  child: Checkbox(
                      value: false,
                      onChanged: (value) async {
                        if (value == true) {
                          task.isFinished = true;
                          await sqliteDB.updateTask(task);
                          Navigator.pushNamedAndRemoveUntil(
                              context, homescreen, (route) => false);
                        }
                      })),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        header,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(date),
                      Text(list),
                    ]),
              ),
            ]),
      ),
    );
  }
}
