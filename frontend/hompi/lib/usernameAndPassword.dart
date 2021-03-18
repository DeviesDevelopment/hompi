import 'package:flutter/material.dart';

class UsernameAndPassword extends StatefulWidget {
  final Function buttonPressed;
  final String buttonText;
  final dynamic errors;

  const UsernameAndPassword({this.buttonPressed, this.buttonText, this.errors});

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

  Widget _buildButton() {
    return RaisedButton(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var usernameError;
    var passwordError;
    if (widget.errors != null) {
      usernameError = widget.errors['username'] != null ? widget.errors['username'].toString(): null;
      passwordError = widget.errors['password1'].toString() != null ? widget.errors['password1'].toString() : null;
    }

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
            decoration: InputDecoration(
              hintText: "Username",
              errorText: usernameError,
            ),
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
            decoration: InputDecoration(
              hintText: "Password",
              errorText: passwordError,
            ),
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
            child: _buildButton(),
          ),
        ),
      ],
    );
  }
}
