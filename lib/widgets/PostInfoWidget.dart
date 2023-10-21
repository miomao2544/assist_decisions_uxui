import 'package:flutter/material.dart';

class PostInfoWidget extends StatelessWidget {
  final String title;
  final String value;

  const PostInfoWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.2),
            borderRadius:
                BorderRadius.circular(15.0), // ค่านี้อาจต้องปรับแต่ละกรณี
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
