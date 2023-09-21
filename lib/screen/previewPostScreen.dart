import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/loginMemberScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constant/constant_value.dart';
import '../widgets/customPostCard.dart';

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

  List<Post> posts = [];
  bool? isDataLoaded = false;
  
  List<Post>? openPosts;
  List<Post>? closedPosts;
  final PostController postController = PostController();
  void fetchPost() async {
    posts = await postController.listAllPosts();
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
                itemCount: openPosts?.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CustomPostCard(
                    postImage: openPosts?[index].postImage ?? '',
                    interestName:
                        openPosts?[index].interest?.interestName ?? '',
                    title: openPosts?[index].title ?? '',
                    description: openPosts?[index].description ?? '',
                    screen: LoginMemberScreen()
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
                    screen: LoginMemberScreen()
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