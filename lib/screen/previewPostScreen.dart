import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/loginMemberScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../constant/constant_value.dart';

class PreviewPostScreen extends StatefulWidget {
  const PreviewPostScreen({super.key});

  @override
  State<PreviewPostScreen> createState() => _PreviewPostScreenState();
}

class _PreviewPostScreenState extends State<PreviewPostScreen> {
  final List<String> movies = [
    "assets/images/page1.png",
    "assets/images/page2.png",
    "assets/images/page3.png",
  ];

  List<Post>? posts;
  bool? isDataLoaded = false;
  final PostController postController = PostController();
  void fetchPost() async {
    posts = await postController.listPostsAfter();
    print(posts?[0].member?.username);

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: 100,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            CarouselSlider(
              items: movies.map((movie) {
                return Container(
                  child: Image.asset(
                    movie,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
            Text(
              "กำลังทำการโหวต",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.left,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                itemCount: posts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(),
                      width: 200,
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(baseURL +
                                  '/posts/downloadimg/${posts?[index].postImage}'),
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
                                  Colors.transparent
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
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "${posts?[index].interest?.interestName}",
                                            style: const TextStyle(
                                                color: Colors.green,
                                                fontFamily: 'Itim',
                                                fontSize: 12),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${posts?[index].title}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 20),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${posts?[index].description}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return LoginMemberScreen();
                                          }));
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
                      ));
                },
              ),
            ),
            Text(
              "ปิดทำการโหวต",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.left,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                itemCount: posts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(),
                      width: 200,
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(baseURL +
                                  '/posts/downloadimg/${posts?[index].postImage}'),
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
                                  Colors.transparent
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
                                          border:
                                              Border.all(color: Colors.amber),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "${posts?[index].interest?.interestName}",
                                            style: const TextStyle(
                                                color: Colors.amber,
                                                fontFamily: 'Itim',
                                                fontSize: 12),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${posts?[index].title}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 20),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${posts?[index].description}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'Itim', fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return LoginMemberScreen();
                                          }));
                                        },
                                        child: Text(
                                          "เพิ่มเติม",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return LoginMemberScreen();
              },
            ));
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
