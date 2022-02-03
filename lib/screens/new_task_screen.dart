import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/task.dart';
import 'package:todolist/sqlite.dart';
import 'package:todolist/main.dart';
import 'package:todolist/screens/routing.dart';

class NewTaskScren extends StatefulWidget {
  const NewTaskScren({Key? key}) : super(key: key);

  @override
  _NewTaskScrenState createState() => _NewTaskScrenState();
}

class _NewTaskScrenState extends State<NewTaskScren> {
  Task task = Task(
      isFinished: false,
      isRepeating: false,
      taskName: "",
      taskListID: 0,
      taskID: -1,
      parentTaskID: null,
      deadlineDate: null,
      deadlineTime: null);
  String? repeatitionFrequency = "No repeat";
  List<String> options = [
    "No repeat",
    "Once a Day",
    "Once a Day(Mon-Fri)",
    "Once a Week",
    "Once a Month",
    "Once a Year"
        "Others"
  ];
  List<DropdownMenuItem<String>> dropDownItemcreator(List<String> itemvalues) {
    List<DropdownMenuItem<String>> dropdownMenuitem = [];
    for (var i = 0; i < itemvalues.length; i++) {
      dropdownMenuitem.add(DropdownMenuItem<String>(
          value: itemvalues[i], child: Text(itemvalues[i])));
    }
    return dropdownMenuitem;
  }

  void saveNewTask() async {
    Map<String, dynamic> taskAsMap = task.toMap();
    taskAsMap.remove("taskID");
    int? taskid = await sqliteDB.insertTask(taskAsMap);
    if (taskid == null) {
    } else {
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, newTaskScreenID, (route) => false);
    }
  }

  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check, size: 35),
          onPressed: () {
            saveNewTask();
          }),
      appBar: AppBar(
        title: Text("New Task"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // task input
            Text(
              "Whats is to be done?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              children: [
                Flexible(
                    child: TextField(
                  decoration: InputDecoration(hintText: "Enter your task"),
                  onChanged: (String? value) {
                    task.taskName = value == null ? task.taskName : value;
                  },
                )),
                CustomIconButton(iconData: Icons.mic, onPressed: () {})
              ],
            ),
            SizedBox(
              height: 80,
            ),
            //Date and time input
            Text(
              "Due Date",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              children: [
                Flexible(
                    child: TextField(
                  readOnly: true,
                  controller: datecontroller,
                  decoration: InputDecoration(hintText: "Date not set"),
                )),
                CustomIconButton(
                  iconData: Icons.calendar_today_outlined,
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: task.deadlineDate == null
                            ? DateTime.now()
                            : task.deadlineDate!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(21021));
                    if (pickedDate != null) {
                      task.deadlineDate = pickedDate;
                      setState(() {});
                      var dateString = DateFormat('EEEE, d MMM,yyyy')
                          .format(task.deadlineDate!);
                      datecontroller.text = dateString;
                    }
                  },
                ),
                Visibility(
                  visible: task.deadlineDate == null ? false : true,
                  child: CustomIconButton(
                    iconData: Icons.cancel_rounded,
                    onPressed: () {
                      task.deadlineDate = null;
                      setState(() {});
                      datecontroller.text = "";
                    },
                  ),
                ),
              ],
            ),
            //Time Input
            Visibility(
              visible: task.deadlineDate == null ? false : true,
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    readOnly: true,
                    controller: timecontroller,
                    decoration: InputDecoration(hintText: "Time not set"),
                  )),
                  CustomIconButton(
                    iconData: Icons.timer,
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (pickedTime != null) {
                        task.deadlineTime = pickedTime;
                        setState(() {});
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        String formattedTime = DateFormat(
                          'HH:mm',
                        ).format(parsedTime);
                        timecontroller.text = formattedTime;
                      }
                    },
                  ),
                  Visibility(
                    visible: task.deadlineTime == null ? false : true,
                    child: CustomIconButton(
                      iconData: Icons.cancel_rounded,
                      onPressed: () {
                        task.deadlineTime = null;
                        setState(() {});
                        timecontroller.text = "";
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70),
            Text(
              "Repeat",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            DropdownButton<String>(
                items: dropDownItemcreator(options),
                value: repeatitionFrequency,
                onChanged: (String? chosenValue) {
                  if (chosenValue != "Others") {
                    repeatitionFrequency = chosenValue!;
                    setState(() {});
                  } else {
                    AlertDialog alert = AlertDialog(
                      content: Text("Content"),
                      actions: [
                        TextButton(onPressed: () {}, child: Text("Cancel")),
                        TextButton(onPressed: () {}, child: Text("Set"))
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);
  final IconData iconData;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Icon(iconData),
      style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 7),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero),
      onPressed: this.onPressed,
    );
  }
}
