import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final Member? member;
  const CommentScreen({required this.member});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
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
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'คอมเม้น',
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        maxLines:
                            null, // ใช้ null เพื่อให้มีจำนวนบรรทัดได้ไม่จำกัด
                        onChanged: (value) {
                          setState(() {
                            // comment = value; // เก็บค่าคอมเม้นที่ป้อนในตัวแปร comment
                          });
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
                        onPressed: () {
                          // ทำสิ่งที่คุณต้องการเมื่อคลิกปุ่ม Comment
                          // if (comment.isNotEmpty) {
                          //   // ตรวจสอบว่าคอมเม้นไม่ว่าง
                          //   print('คอมเม้น: $comment');
                          // }
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
        ],
      ),
    );
  }
}
