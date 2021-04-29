import 'package:flutter/material.dart';
import 'package:notebook/screens/signup_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SignUp {}
