import 'package:flutter/material.dart';

class UsernameAndPassword extends StatefulWidget {
  final Function buttonPressed;
  final String buttonText;

  const UsernameAndPassword({this.buttonPressed, this.buttonText});

  @override
  _UsernameAndPasswordState createState() => _UsernameAndPasswordState(buttonPressed, buttonText);
}

class _UsernameAndPasswordState extends State<UsernameAndPassword> {
  final Function buttonPressed;
  final String buttonText;

  TextEditingController _usernameController = TextEditingController();
  String usernameInput;

  TextEditingController _passwordController = TextEditingController();
  String passwordInput;

  _UsernameAndPasswordState(this.buttonPressed, this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Text(buttonText),
          onPressed: () {
            buttonPressed(usernameInput, passwordInput);
          },
        ),
      ],
    );
  }
}
