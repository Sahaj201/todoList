import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTaskScren extends StatefulWidget {
  const NewTaskScren({Key? key}) : super(key: key);

  @override
  _NewTaskScrenState createState() => _NewTaskScrenState();
}

class _NewTaskScrenState extends State<NewTaskScren> {
  @override
  DateTime? date = null;
  TimeOfDay? time = null;
  String? repeatitionFrequency = "No repeat";
  List<String> options = [
    "No repeat",
    "Once a Day",
    "Once a Day(Mon-Fri)",
    "Once a Week",
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

  TextEditingController datecontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
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
                        initialDate: date == null ? DateTime.now() : date!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(21021));
                    if (pickedDate != null) {
                      date = pickedDate;
                      setState(() {});
                      var dateString =
                          DateFormat('EEEE, d MMM,yyyy').format(date!);
                      datecontroller.text = dateString;
                    }
                  },
                ),
                Visibility(
                  visible: date == null ? false : true,
                  child: CustomIconButton(
                    iconData: Icons.cancel_rounded,
                    onPressed: () {
                      date = null;
                      setState(() {});
                      datecontroller.text = "";
                    },
                  ),
                ),
              ],
            ),
            //Time Input
            Visibility(
              visible: date == null ? false : true,
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
                        time = pickedTime;
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
                    visible: time == null ? false : true,
                    child: CustomIconButton(
                      iconData: Icons.cancel_rounded,
                      onPressed: () {
                        time = null;
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
