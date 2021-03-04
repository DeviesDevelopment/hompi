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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: TextField(
            onChanged: (value) {
              setState(() {
                usernameInput = value;
              });
            },
            controller: _usernameController,
            decoration: InputDecoration(hintText: "Username"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: TextField(
            onChanged: (value) {
              setState(() {
                passwordInput = value;
              });
            },
            controller: _passwordController,
            decoration: InputDecoration(hintText: "Password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: ButtonTheme(
            minWidth: 200.0,
            height: 42.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green)),
              onPressed: () {
                buttonPressed(usernameInput, passwordInput);
              },
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text(buttonText.toUpperCase(),
                  style: TextStyle(fontSize: 15)),
            ),
          ),
        ),

      ],
    );
  }
}