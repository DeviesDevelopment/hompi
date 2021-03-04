import 'package:flutter/material.dart';
import 'package:hompi/usernameAndPassword.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

getBaseUrl() {
  return 'https://hompi-backend.herokuapp.com/api/';

  // For local development:
  /*if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api/';
  } else {
    return 'http://127.0.0.1:8000/api/';
  }*/
}

Future<void> createUser(String username, String password, BuildContext context) async {
  print("Logging in...");
  final response = await http.post(
    getBaseUrl() + 'dj-rest-auth/registration/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password1': password,
      'password2': password,
    }),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to login');
  }

  var body = jsonDecode(response.body);
  String token = body['key'];
  print("Logged in, saving token in shared preferences");
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);

  Navigator.pushNamedAndRemoveUntil(context, "/tasks", (r) => false);
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hompi'),
      ),
      body: Column(
        children: [
          UsernameAndPassword(
            buttonText: 'Create User',
            buttonPressed: (String username, String password) {
              createUser(username, password, context);
            },
          ),
        ],
      ),
    );
  }
}
