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
      width: 200,
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
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: SecondColor.withOpacity(0.3),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: SecondColor,
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '${widget.interestName}', // เพิ่มคำว่า "หมวดหมู่" ที่นี่
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Light',
                            ),
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
                      fontFamily: 'Light',
                      fontSize: 16,
                      color: MainColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 85,
                        height: 20,
                        child: Text(
                          maxLines: 1,
                          widget.description,
                          style: TextStyle(
                            fontFamily: 'Light',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: MainColor.withOpacity(0.4),
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
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
                                fontFamily: 'Light',
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: MainColor,
                            ),
                          ),
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
