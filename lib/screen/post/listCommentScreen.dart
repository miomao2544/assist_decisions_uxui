import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/commentController.dart';
import 'package:assist_decisions_app/model/comment.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ListCommentScreen extends StatefulWidget {
  final String postId;
  const ListCommentScreen({required this.postId});

  @override
  State<ListCommentScreen> createState() => _ListCommentScreenState();
}

class _ListCommentScreenState extends State<ListCommentScreen> {
  List<Comment>? commentList;
  bool isDataLoaded = false;
  CommentController commentController = CommentController();

  Future fetchComment() async {
    List<Comment> comments;
    comments =
        await commentController.findCommentById(widget.postId.toString());
    setState(() {
      commentList = comments;
      isDataLoaded = true;
    });
  }

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    fetchComment();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          isDataLoaded
              ? commentList!.length > 0? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: commentList!.length >= 5 ? 5 : commentList!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(
                                16), // Padding inside the ListTile.
                            leading: 
                                            Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: SecondColor,
                      width: 4.0,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      baseURL +
                                    '/members/downloadimg/${commentList![index].member!.image.toString()}',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                            title: Text(
                              "${commentList![index].member!.nickname.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            subtitle: Text(
                              commentList![index].comment.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            isThreeLine:
                                true, // Makes the subtitle take up the full width.
                            trailing: Text(
                              formatDate(commentList![index].commentDate),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ):Text("ไม่มีคอมเม้น")
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
