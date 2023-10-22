import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/post/postDetailScreen.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:assist_decisions_app/widgets/customNewCard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MemberScreen extends StatefulWidget {
  final String username;
  const MemberScreen({required this.username});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final List<String> movies = [
    "assets/images/bg01.png",
    "assets/images/bg02.png",
  ];

  List<Post>? posts = [];
  bool? isDataLoaded = false;

  List<Post>? openPosts = [];
  List<Post>? closedPosts = [];

  final PostController postController = PostController();

  void fetchPost() async {
    posts = await postController.listPostsMember(widget.username);
    openPosts = [];
    closedPosts = [];

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [MainColor, Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            CarouselSlider(
              items: movies.map((movie) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    movie,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 170.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),
      Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "กำลังดำเนินการ",
                    style: TextStyle(
                        fontSize: 25, fontFamily: 'Kanit', color: MainColor2),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "โพสต์ทั้งหมด",
                    style: TextStyle(
                        fontSize: 16, fontFamily: 'Kanit', color: MainColor2),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
      
            isDataLoaded == true
                ? Container(
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
                          screen: widget.username ==
                                  openPosts?[index].member?.username
                              ? PostDetailScreen(
                                  postId: openPosts![index].postId.toString(),
                                  username: widget.username.toString(),
                                )
                              : ViewPostScreen(
                                  postId: openPosts![index].postId.toString(),
                                  username: widget.username.toString()),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: 200,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "ดำเนินการเสร็จสิ้น",
                  style: TextStyle(
                      fontSize: 25, fontFamily: 'Kanit', color: MainColor2),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 10,),
                Text(
                  "โพสต์ทั้งหมด",
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Kanit', color: MainColor2),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            isDataLoaded == true
                ? Container(
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
                          screen: widget.username ==
                                  closedPosts?[index].member?.username
                              ? PostDetailScreen(
                                  postId: closedPosts![index].postId.toString(),
                                  username: widget.username.toString(),
                                )
                              : ViewPostScreen(
                                  postId: closedPosts![index].postId.toString(),
                                  username: widget.username.toString()),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: 200,
                  ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
