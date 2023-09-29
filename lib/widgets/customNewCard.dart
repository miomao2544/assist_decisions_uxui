import 'package:flutter/material.dart';

import '../constant/constant_value.dart';
class CustomNewCard extends StatefulWidget {
  final String postImage;
  final String interestName;
  final String title;
  final String description;
  final Widget screen;
   CustomNewCard({
    required this.postImage,
    required this.interestName,
    required this.title,
    required this.description,
    required this.screen
  });

  @override
  State<CustomNewCard> createState() => _CustomNewCardState();
}

class _CustomNewCardState extends State<CustomNewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "หมวดหมู่", // เพิ่มคำว่า "หมวดหมู่" ที่นี่
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      Image(
        image: NetworkImage('$baseURL/posts/downloadimg/1695739819474.png'),
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "title",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[800],
              ),
            ),
            Container(height: 10),
            Text(
              "title",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "เพิ่มเติม",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(height: 5),
    ],
  ),
);

  }
}
