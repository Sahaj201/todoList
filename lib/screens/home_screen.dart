import 'package:todolist/main.dart';
import 'package:flutter/material.dart';
import 'routing.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
      body: Container(
        child: ListView(padding: EdgeInsets.all(5), children: [
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
        ]),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard(
    this.header,
    this.date,
    this.list, {
    Key? key,
  }) : super(key: key);
  final String header;
  final String date;
  final String list;
  @override
  Widget build(BuildContext context) {
    return Card(
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
                onChanged: (bool? value) {},
              ),
            ),
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
    );
  }
}
