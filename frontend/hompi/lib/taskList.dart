import 'package:flutter/material.dart';
import 'package:hompi/completeTaskDialog.dart';
import 'package:hompi/createTaskDialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:hompi/task.dart';

getBaseUrl() {
  return 'https://hompi-backend.herokuapp.com/api/';

  // For local development:
  /*if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api/';
  } else {
    return 'http://127.0.0.1:8000/api/';
  }*/
}

Future<List<Task>> fetchTasks() async {
  print("Fetching tasks");
  final response = await http.get(getBaseUrl());
  print("Got response: "+ response.statusCode.toString());
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    return list.map((model) => Task.fromJson(model)).toList();
  } else {
    throw Exception('Failed to load tasks');
  }
}

Future<void> addTask(Task task) async {
  final response = await http.post(
    getBaseUrl(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': task.title,
      'due_date': task.dueDate.toIso8601String(),
      'interval': task.interval,
    }),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to create task');
  }
}

Future<void> updateTask(Task task) async {
  final response = await http.put(
    getBaseUrl() + task.id.toString() + "/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': task.id.toString(),
      'title': task.title,
      'due_date': task.dueDate.toIso8601String(),
      'interval': task.interval,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update task');
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _tasks = <Task>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  initState() {
    super.initState();
    fetchTasks().then((tasks) {
      setState(() {
        _tasks.addAll(tasks);
      });
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

  _markTaskAsComplete(Task task) async {
    task.dueDate = DateTime.now().add(new Duration(days: task.getIntervalInDays()));
    await updateTask(task);
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
          return CreateTaskDialog(
            createTask: (Task task) {
              _addTask(task);
            },
          );
        });
  }

  Future<void> _displayCompleteTaskDialog(BuildContext context, Task task) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CompleteTaskDialog(
            task: task,
            markAsComplete: (Task task) {
              _markTaskAsComplete(task);
            },
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
      onTap: () {
        _displayCompleteTaskDialog(context, task);
      },
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
