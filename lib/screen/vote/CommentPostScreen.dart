import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/CommentPostController.dart';

import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/vote/ListCommentScreen.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

class CommentPostScreen extends StatefulWidget {
  final Member? member;
  final String? postId;
  const CommentPostScreen({required this.member, required this.postId});

  @override
  State<CommentPostScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentPostScreen> {
  String comment = "";
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  CommentPostController commentController = CommentPostController();

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
                                  fontSize: 16.0,fontFamily: 'Light'
                                ),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                key: Key('comment'),
                                decoration: InputDecoration(
                                    labelText: 'คอมเม้น',
                                    labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                                    prefixIconColor: MainColor,
                                    prefixStyle: TextStyle(color: MainColor,fontFamily: 'Light')),
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
                                    await commentController.doCommentPost(
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
