import 'package:assist_decisions_app/classcontroller/postController.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

class CancelPostScreen extends StatefulWidget {
  final String postId;
  final String username;
  const CancelPostScreen({required this.postId, required this.username});

  @override
  State<CancelPostScreen> createState() => _ChackDeletePostScreenState();
}

class _ChackDeletePostScreenState extends State<CancelPostScreen> {
  PostController postController = PostController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  width: 280,
                  height: 400,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 250,
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: Text(
                          "คุณแน่ใจหรือไม่ว่าจะลบโพสต์นี้",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Light'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await postController
                                      .doDeletePost(widget.postId.toString());
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomeScreen(
                                      username: widget.username.toString(),
                                    );
                                  }));
                                },
                                child: Text(
                                  "ตกลง",
                                  style: TextStyle(fontFamily: 'Light'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: MainColor2,
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "ยกเลิก",
                                  style: TextStyle(fontFamily: 'Light'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: MainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Text('ลบ',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Light')),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
        ),
      ),
    );
  }
}
