import 'package:assist_decisions_app/controller/PreviewPostController.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/vote/loginMemberScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:assist_decisions_app/widgets/customNewCard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PreviewPostScreen extends StatefulWidget {
  const PreviewPostScreen({super.key});

  @override
  State<PreviewPostScreen> createState() => _PreviewPostScreenState();
}

class _PreviewPostScreenState extends State<PreviewPostScreen> {
  final List<String> movies = [
    "assets/images/bg01.png",
    "assets/images/bg02.png",
  ];

  List<Post>? posts = [];
  bool? isDataLoaded = false;

  List<Post>? openPosts = [];
  List<Post>? closedPosts = [];
  final PreviewPostController previewPostController = PreviewPostController();
  void fetchPost() async {
    posts = await previewPostController.getPreviewPost();
    for (int i = 0; i < posts!.length; i++) {
      if (posts![i].result.toString() == "r") {
        openPosts!.add(posts![i]);
      } else {
        closedPosts!.add(posts![i]);
      }
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 60,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Assist Decisions',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: MainColor),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
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
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
            Text(
              "กำลังทำการโหวต",
              style: TextStyle(fontSize: 25,fontFamily: 'Light'),
              textAlign: TextAlign.left,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height / 4.3,
              child: ListView.builder(
                itemCount: openPosts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomNewCard(
                      postImage: openPosts?[index].postImage ?? '',
                      interestName:
                          openPosts?[index].interest?.interestName ?? '',
                      title: openPosts?[index].title ?? '',
                      description: openPosts?[index].description ?? '',
                      screen: LoginMemberScreen());
                },
              ),
            ),
            Text(
              "ปิดทำการโหวต",
              style: TextStyle(fontSize: 25,fontFamily: 'Light'),
              textAlign: TextAlign.left,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height / 4.3,
              child: ListView.builder(
                itemCount: closedPosts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomNewCard(
                      postImage: closedPosts?[index].postImage ?? '',
                      interestName:
                          closedPosts?[index].interest?.interestName ?? '',
                      title: closedPosts?[index].title ?? '',
                      description: closedPosts?[index].description ?? '',
                      screen: LoginMemberScreen());
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: MainColor, // สีพื้นหลังของ BottomAppBar
        child: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return LoginMemberScreen();
              },
            ));
          },
          icon: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // กำหนดให้รูปร่างเป็นวงกลม
              color: MainColor2, // สีพื้นหลังของวงกลม
               boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            spreadRadius: 6,
          ),
        ],
            ),
            child: Icon(
              Icons.login, // ใส่ไอคอนที่คุณต้องการแสดง
              color: Colors.white, // สีไอคอน
              size: 30, // กำหนดขนาดไอคอน
            ),
          ),
        ),
      ),
    );
  }
}
