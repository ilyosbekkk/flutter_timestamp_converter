import 'dart:async';

import 'package:flutter/material.dart';

import 'package:timestamp_converter/timestamp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter  Pro',
      theme: ThemeData(
        fontFamily: 'Trajan pro',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {"/": (context) => TimeStamp()},
    );
  }
}
