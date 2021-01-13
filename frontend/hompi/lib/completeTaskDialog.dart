import 'package:flutter/material.dart';
import 'package:hompi/task.dart';

class CompleteTaskDialog extends StatelessWidget {
  final Task task;
  final Function markAsComplete;

  CompleteTaskDialog({this.task, this.markAsComplete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(task.title),
      content: Text("Repeats every " + task.getIntervalInDays().toString() + " days."),
      actions: <Widget>[
        FlatButton(
          color: Colors.green,
          textColor: Colors.white,
          child: Text('MARK AS COMPLETE'),
          onPressed: () {
            markAsComplete(task);
            Navigator.pop(context);
          },
        ),

      ],
    );
  }
}
