import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/screen/homeScreen.dart';
import 'package:flutter/material.dart';

class ChackDeletePostScreen extends StatefulWidget {
  final String postId;
  final String username;
  const ChackDeletePostScreen({required this.postId ,required this.username});

  @override
  State<ChackDeletePostScreen> createState() => _ChackDeletePostScreenState();
}

class _ChackDeletePostScreenState extends State<ChackDeletePostScreen> {
   PostController postController = PostController();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show the image popup
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
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: ()async{
                              await postController.doDeletePost(widget.postId.toString());
                               Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return HomeScreen(username:widget.username.toString(),);
                                        }));
                              },
                              child: Text("ตกลง"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("ยกเลิก"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber,
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
      child: Text('ลบ'),
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 255, 191, 0),
      ),
    );
  }
}
