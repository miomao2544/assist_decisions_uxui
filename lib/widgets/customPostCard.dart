
import 'package:flutter/material.dart';

import '../constant/constant_value.dart';

class CustomPostCard extends StatelessWidget {
  final String postImage;
  final String interestName;
  final String title;
  final String description;
  final Widget screen;

  CustomPostCard({
    required this.postImage,
    required this.interestName,
    required this.title,
    required this.description,
    required this.screen
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      width: 200,
      height: 100,
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(baseURL + '/posts/downloadimg/$postImage'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white.withOpacity(1),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          interestName,
                          style: const TextStyle(
                            color: Colors.green,
                            fontFamily: 'Itim',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return screen;
                            },
                          ),
                        );
                      },
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
        ),
      ),
    ],
  ),
)

    );
  }
}
