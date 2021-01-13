import 'package:flutter/material.dart';
import 'package:hompi/task.dart';

class CompleteTaskDialog extends StatelessWidget {
  final Task task;

  CompleteTaskDialog({this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(task.title),
      content: Text("Repeats every " + task.interval + " days."),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          textColor: Colors.white,
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          color: Colors.green,
          textColor: Colors.white,
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ],
    );
  }
}
