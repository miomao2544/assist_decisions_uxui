import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/postDetailScreen.dart';
import 'package:assist_decisions_app/screen/viewPostScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/customPostCard.dart';

class MemberScreen extends StatefulWidget {
  final String username;
  const MemberScreen({required this.username});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final List<String> movies = [
    "assets/images/page1.png",
    "assets/images/page2.png",
    "assets/images/page3.png",
  ];

  List<Post> posts = [];
  bool? isDataLoaded = false;

  List<Post>? openPosts;
  List<Post>? closedPosts;

  final PostController postController = PostController();

  void fetchPost() async {
    posts = await postController.listPostsInterest(widget.username);
    final now = DateTime.now();
    final dateFormatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZZZZZ');

    try {
      openPosts = posts
          .where((post) => dateFormatter.parse(post.dateStop!).isAfter(now))
          .toList();
      closedPosts = posts
          .where((post) => dateFormatter.parse(post.dateStop!).isBefore(now))
          .toList();
    } catch (e) {
      print("Error parsing date: $e");
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
            Text("Username is : ${widget.username}"),
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
                itemCount: openPosts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomPostCard(
                    postImage: openPosts?[index].postImage ?? '',
                    interestName:
                        openPosts?[index].interest?.interestName ?? '',
                    title: openPosts?[index].title ?? '',
                    description: openPosts?[index].description ?? '',
                    screen: widget.username ==  openPosts?[index].postId? PostDetailScreen(post: null,):ViewPostScreen(postId: openPosts![index].postId.toString(),username: widget.username.toString()),
                  );
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
                itemCount: closedPosts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomPostCard(
                    postImage: closedPosts?[index].postImage ?? '',
                    interestName:
                        closedPosts?[index].interest?.interestName ?? '',
                    title: closedPosts?[index].title ?? '',
                    description: closedPosts?[index].description ?? '',
                    screen: widget.username ==  closedPosts?[index].postId? PostDetailScreen(post: null,):ViewPostScreen(postId: closedPosts![index].postId.toString(),username: widget.username.toString()),
                  );
                },
              ),
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
