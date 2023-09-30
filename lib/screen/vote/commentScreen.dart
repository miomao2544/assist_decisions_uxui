import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/commentController.dart';

import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/post/listCommentScreen.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final Member? member;
  final String? postId;
  const CommentScreen({required this.member, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String comment = "";
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  CommentController commentController = CommentController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: MainColor,
                      width: 4.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      baseURL + '/members/downloadimg/${widget.member?.image}',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Form(
                    key: fromKey,
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.member!.nickname}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'คอมเม้น',
                                    labelStyle: TextStyle(color: MainColor),
                                    prefixIconColor: MainColor,
                                    prefixStyle: TextStyle(color: MainColor)),
                                maxLines: null,
                                onChanged: (value) {
                                  setState(() {
                                    comment = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกคอมเมนต์';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (fromKey.currentState!.validate()) {
                                    await commentController.addChoice(
                                        comment.toString(),
                                        widget.member!.username.toString(),
                                        widget.postId.toString());

                                    fromKey.currentState!.reset();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ViewPostScreen(
                                        postId: widget.postId.toString(),
                                        username:
                                            widget.member!.username.toString(),
                                      );
                                    }));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      MainColor, // Change this to your desired color
                                ),
                                child: Icon(Icons.add_comment_sharp,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ListCommentScreen(postId: widget.postId.toString()),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}
