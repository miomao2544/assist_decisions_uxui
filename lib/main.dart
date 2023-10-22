
import 'package:assist_decisions_app/screen/admin/listReportScreen.dart';
import 'package:assist_decisions_app/screen/admin/loginAdminScreen.dart';
import 'package:assist_decisions_app/screen/admin/viewReportPostDetailScreen.dart';
import 'package:assist_decisions_app/screen/user/previewPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/screen/vote/loginMemberScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      // home: PreviewPostScreen(),
      // home: LoginMemberScreen(),
      home: HomeScreen(username: 'sandee2544'),
      // home: ListReportScreen(username: 'adminmember'),
      // home: ViewReportPostDetail(username: 'adminmember',reportId: 'R00000000002',),
      debugShowCheckedModeBanner: false,
    );
  }
}
