import 'package:flutter/material.dart';
import 'package:hompi/completeTaskDialog.dart';
import 'package:hompi/createTaskDialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:hompi/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

getBaseUrl() {
  return 'https://hompi-backend.herokuapp.com/api/';

  // For local development:
  /*if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api/';
  } else {
    return 'http://127.0.0.1:8000/api/';
  }*/
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  Navigator.pushReplacementNamed(context, '/login');
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  print("Your token is $token");
  return token;
}

Future<List<Task>> fetchTasks(BuildContext context) async {
  print("Fetching tasks");

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  print("Your token is $token");

  if (token == "") {
    Navigator.pushReplacementNamed(context, '/login');
  }

  final response = await http.get(
    getBaseUrl(),
    headers: <String, String>{
      'Authorization': 'Token $token',
    },
  );
  print("Got response: "+ response.statusCode.toString());
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    Iterable list = json.decode(body);
    return list.map((model) => Task.fromJson(model)).toList();
  } else {
    print('Failed to fetch tasks: ' + response.statusCode.toString());
  }
}

Future<void> addTask(Task task, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? "";
  if (token == "") {
    Navigator.pushReplacementNamed(context, '/login');
  }

  final response = await http.post(
    getBaseUrl(),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: jsonEncode(<String, String>{
      'title': task.title,
      'due_date': task.dueDate.toIso8601String(),
      'interval': task.interval,
    }),
  );
  if (response.statusCode != 201) {
    print('Failed to add task: ' + response.statusCode.toString());
  }
}

Future<void> updateTask(Task task) async {
  String token = await getToken();
  final response = await http.put(
    getBaseUrl() + task.id.toString() + "/",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
    body: jsonEncode(<String, String>{
      'id': task.id.toString(),
      'title': task.title,
      'due_date': task.dueDate.toIso8601String(),
      'interval': task.interval,
    }),
  );
  if (response.statusCode != 200) {
    print('Failed to update task: ' + response.statusCode.toString());
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<List<Task>> _tasks;
  
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  initState() {
    super.initState();
    _tasks = fetchTasks(context);
  }

  _addTask(Task task, BuildContext context) async {
    await addTask(task, context);
    fetchTasks(context).then((tasks) {
      setState(() {
        _tasks = fetchTasks(context);
      });
    });
  }

  _markTaskAsComplete(Task task, BuildContext context) async {
    task.dueDate = DateTime.now().add(new Duration(days: task.getIntervalInDays()));
    await updateTask(task);
    fetchTasks(context).then((tasks) {
      setState(() {
        _tasks = fetchTasks(context);
      });
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CreateTaskDialog(
            createTask: (Task task) {
              _addTask(task, context);
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
              _markTaskAsComplete(task, context);
            },
          );
        });
  }

  Widget _buildTasks() {
    return FutureBuilder<List<Task>>(
      future: _tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();

                final index = i ~/ 2;
                return _buildRow(snapshot.data[index]);
              });
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRow(Task task) {
    return ListTile(
      title: Text(
        task.title,
        style: _biggerFont,
      ),
      subtitle: _buildDueDate(task.dueDate),
      onTap: () {
        _displayCompleteTaskDialog(context, task);
      },
    );
  }

  Widget _buildDueDate(DateTime dueDate) {
    return Text("Due on " + DateFormat('yyyy-MM-dd').format(dueDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hompi'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await logout(context);
              },
            ),
          ]
        ),
        body: _buildTasks(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayTextInputDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
