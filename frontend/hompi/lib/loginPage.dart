import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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

Future<void> login(String username, String password, BuildContext context) async {
  print("Logging in...");
  final response = await http.post(
    getBaseUrl() + 'dj-rest-auth/login/',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to login');
  }

  var body = jsonDecode(response.body);
  String token = body['key'];
  print("Logged in, saving token in shared preferences");
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);

  Navigator.pushReplacementNamed(context, '/tasks');
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  String usernameInput;

  TextEditingController _passwordController = TextEditingController();
  String passwordInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hompi'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                usernameInput = value;
              });
            },
            controller: _usernameController,
            decoration: InputDecoration(hintText: "Username"),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                passwordInput = value;
              });
            },
            controller: _passwordController,
            decoration: InputDecoration(hintText: "Password"),
          ),
          FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('Login'),
            onPressed: () {
              login(usernameInput, passwordInput, context);
            },
          ),
          Divider(),
          Text("Not registered yet?"),
          FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('Create New User'),
            onPressed: () {
              Navigator.pushNamed(context, '/registration');
            },
          ),
        ],
      ),
    );
  }
}
