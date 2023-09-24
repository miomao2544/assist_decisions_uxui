import 'package:assist_decisions_app/screen/addPostScreen.dart';
import 'package:assist_decisions_app/screen/homeScreen.dart';
import 'package:assist_decisions_app/screen/previewPostScreen.dart';
import 'package:assist_decisions_app/screen/searchPostScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: PreviewPostScreen(),
      home: HomeScreen(username: "post",),
      debugShowCheckedModeBanner: false,
    );
  }
}
