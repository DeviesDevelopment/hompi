import 'package:flutter/material.dart';
import 'package:hompi/loginPage.dart';
import 'package:hompi/taskList.dart';
import 'package:hompi/registrationPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hompi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskList(),
      routes: {
        '/login': (context) => LoginPage(),
        '/tasks': (context) => TaskList(),
        '/registration': (context) => RegistrationPage(),
      },
    );
  }
}
