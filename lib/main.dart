import 'package:assist_decisions_app/screen/homeScreen.dart';
import 'package:assist_decisions_app/screen/listCommentScreen.dart';
import 'package:assist_decisions_app/screen/listReportScreen.dart';
import 'package:assist_decisions_app/screen/loginAdminScreen.dart';
import 'package:assist_decisions_app/screen/previewPostScreen.dart';
import 'package:assist_decisions_app/screen/viewReportPostDetailScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: ViewReportPostDetail(reportId: "R00000000001",username:"post",),
      // home: HomeScreen(username: "post",),
      debugShowCheckedModeBanner: false,
    );
    
  }
}
