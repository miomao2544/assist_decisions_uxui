
import 'package:assist_decisions_app/screen/admin/loginAdminScreen.dart';
import 'package:assist_decisions_app/screen/user/previewPostScreen.dart';
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
      home: PreviewPostScreen(),
      // home: LoginAdminScreen(),
      // home: LoginMemberScreen(),
      debugShowCheckedModeBanner: false,
    );
    
  }
}
