import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/comment_controller.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final Member? member;
  final String? postId;
  const CommentScreen({required this.member, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String? comment;
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  CommentController commentController = CommentController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Image.network(
              baseURL + '/members/downloadimg/${widget.member?.image}',
              fit: BoxFit.cover,
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
                            labelStyle: TextStyle(color: Color(0xFF1c174d)),
                          ),
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
                            }
                            fromKey.currentState!.reset();
                          },
                          child: Icon(Icons.add_comment_sharp,
                              color: Color(0xFF1c174d)),
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
    );
  }
}
