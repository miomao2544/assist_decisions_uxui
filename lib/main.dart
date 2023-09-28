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

      // // home: HomeScreen(username: "post",),
      home: LoginMemberScreen(),
      debugShowCheckedModeBanner: false,
    );
    
  }
}
