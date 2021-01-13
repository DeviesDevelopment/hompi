import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

void main() => runApp(MyApp());

getBaseUrl() {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api/';
  } else {
    return 'http://127.0.0.1:8000/api/';
  }
}

Future<List<Task>> fetchTasks() async {
  final response = await http.get(getBaseUrl());
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    return list.map((model) => Task.fromJson(model)).toList();
  } else {
    throw Exception('Failed to load tasks');
  }
}

void addTask(Task task) async {
  final response = await http.post(
      getBaseUrl(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    body: jsonEncode(<String, String>{
      'title': task.title,
      'due_date': task.dueDate.toIso8601String(),
      'interval': task.interval + ' 00:00:00',
    }),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to create task');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hompi',
      home: RandomWords(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _tasks = <Task>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  TextEditingController _titleTextFieldController = TextEditingController();
  String titleInputText;
  TextEditingController _intervalTextFieldController = TextEditingController();
  String intervalInputText;

  @override
  initState() {
    super.initState();
    fetchTasks().then((tasks) {
      _tasks.addAll(tasks);
    });
  }

  _addTask(Task task) async {
    await addTask(task);
    fetchTasks().then((tasks) {
      setState(() {
        _tasks.clear();
        _tasks.addAll(tasks);
      });
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
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
                    _addTask(newTask);
                    Navigator.pop(context);
                    _titleTextFieldController.text = "";
                    _intervalTextFieldController.text = "";
                  });
                },
              ),

            ],
          );
        });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _tasks.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return _buildRow(_tasks[index]);
        });
  }

  Widget _buildRow(Task task) {
    return ListTile(
      title: Text(
        task.title,
        style: _biggerFont,
      ),
      subtitle: Text(task.dueDate.toIso8601String()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hompi'),
        ),
        body: _buildSuggestions(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayTextInputDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}

class Task {
  int id;
  final String title;
  final DateTime dueDate;
  final String interval;

  Task({this.id, this.title, this.dueDate, this.interval});

  Task.dummy({this.title, this.dueDate, this.interval});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      dueDate: DateTime.parse(json['due_date']),
      interval: json['interval'],
    );
  }
}
