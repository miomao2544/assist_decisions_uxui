import 'package:assist_decisions_app/screen/post/addPostScreen.dart';
import 'package:assist_decisions_app/screen/post/editPostScreen.dart';
import 'package:assist_decisions_app/screen/user/previewPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/loginMemberScreen.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
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
      // home: EditPostScreen(username: "post",postId: "P00000000012",),
      home: PreviewPostScreen(),
      debugShowCheckedModeBanner: false,
    );
    
  }
}
