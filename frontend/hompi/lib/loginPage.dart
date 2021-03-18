import 'package:flutter/material.dart';
import 'package:hompi/usernameAndPassword.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;

  Future<void> login(String username, String password) async {
    print("Logging in...");
    setState(() {
      _loading = true;
    });

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

    setState(() {
      _loading = false;
    });

    if (response.statusCode != 200) {
      print('Failed to login: ' + response.statusCode.toString());
    }

    var body = jsonDecode(response.body);
    String token = body['key'];
    print("Logged in, saving token in shared preferences");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    Navigator.pushReplacementNamed(context, '/tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hompi'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Column(
          children: [
            UsernameAndPassword(
              buttonText: 'Login',
              buttonPressed: (String username, String password) {
                login(username, password);
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Not registered yet?"),
            ),
            FlatButton(
              color: Theme.of(context).canvasColor,
              textColor: Theme.of(context).accentColor,
              child: Text(
                'Create New User',
                style: TextStyle(fontSize: 17),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
            ),
          ],
        ),
      ),
    );
  }
}
