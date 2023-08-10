import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextFormField(
          decoration: InputDecoration(
        hintText: "Email",
        suffixIcon: Icon(Icons.email_rounded),
      )),
      SizedBox(
        height: 15.0,
      ),
      TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
          )),
      SizedBox(
        height: 25.0,
      ),
      ElevatedButton(
        onPressed: () {},
        child: Text("Let's go!"),
      ),
    ]));
  }
}
