import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

import '../constant/constant_value.dart';

class CustomNewCard extends StatefulWidget {
  final String postImage;
  final String interestName;
  final String title;
  final String description;
  final Widget screen;
  CustomNewCard(
      {required this.postImage,
      required this.interestName,
      required this.title,
      required this.description,
      required this.screen});

  @override
  State<CustomNewCard> createState() => _CustomNewCardState();
}

class _CustomNewCardState extends State<CustomNewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      width: 230,
      height: 180,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Image(
                    image: NetworkImage(
                        '$baseURL/posts/downloadimg/${widget.postImage}'),
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20), // ปรับขนาดของมุมโค้งตามที่คุณต้องการ
                      child: Container(
                        color: MainColor, // สีพื้นหลังของข้อความ
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${widget.interestName}', // เพิ่มคำว่า "หมวดหมู่" ที่นี่
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white, // สีข้อความ
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.title}",
                    style: TextStyle(
                      fontSize: 16,
                      color: MainColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 20,
                        child: Text(
                           maxLines: 1,
                          widget.description,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return widget.screen;
                              },
                            ),
                          );
                        },
                        child: Text(
                          "เพิ่มเติม",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: MainColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
