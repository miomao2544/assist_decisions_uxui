import 'package:assist_decisions_app/screen/homeScreen.dart';
import 'package:assist_decisions_app/screen/listCommentComment.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeScreen(username: "vote",),
      debugShowCheckedModeBanner: false,
    );
  }
}
