import 'package:flutter/material.dart';
import 'package:hompi/task.dart';

class CreateTaskDialog extends StatefulWidget {
  final Function createTask;

  CreateTaskDialog({this.createTask});

  @override
  _CreateTaskDialogState createState() => _CreateTaskDialogState(createTask: this.createTask);
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final Function createTask;

  TextEditingController _titleTextFieldController = TextEditingController();
  String titleInputText;
  TextEditingController _intervalTextFieldController = TextEditingController();
  String intervalInputText;

  _CreateTaskDialogState({this.createTask});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create new task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                titleInputText = value;
              });
            },
            controller: _titleTextFieldController,
            decoration: InputDecoration(hintText: "Title"),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                intervalInputText = value;
              });
            },
            controller: _intervalTextFieldController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Interval in days"),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.red,
          textColor: Colors.white,
          child: Text('CANCEL'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _titleTextFieldController.text = "";
              _intervalTextFieldController.text = "";
            });
          },
        ),
        FlatButton(
          color: Colors.green,
          textColor: Colors.white,
          child: Text('OK'),
          onPressed: () {
            setState(() {
              Task newTask = Task.dummy(
                  title: titleInputText,
                  dueDate: DateTime.now().add(new Duration(days: int.parse(intervalInputText))),
                  interval: intervalInputText
              );
              createTask(newTask);
              Navigator.pop(context);
              _titleTextFieldController.text = "";
              _intervalTextFieldController.text = "";
            });
          },
        ),

      ],
    );
  }
}
