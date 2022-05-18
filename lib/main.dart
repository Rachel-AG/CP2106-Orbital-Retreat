import 'package:flutter/material.dart';
import 'package:retreat/screens/signin_page/signin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retreat',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const SignInPage(),
    );
  }
}
