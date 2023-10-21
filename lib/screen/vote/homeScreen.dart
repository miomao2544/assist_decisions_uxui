import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/controller/voteController.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/post/chackPointScreen.dart';
import 'package:assist_decisions_app/screen/post/addPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/listPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/loginMemberScreen.dart';
import 'package:assist_decisions_app/screen/vote/memberScreen.dart';
import 'package:assist_decisions_app/screen/vote/notifyPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/searchPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/viewProfileScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:assist_decisions_app/widgets/myNotificationWidget%20.dart';
import 'package:flutter/material.dart';

import '../../constant/constant_value.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedChoice = 0;
  bool isDataLoaded = false;
  int currentState = 0;
  String username = '';
  String? imageUser = '';
  List<Widget> widgets = [];
  List<Post>? posts;
  final MemberController memberController = MemberController();
  final PostController postController = PostController();
  final VoteController voteController = VoteController();
  Member? member;

  void fetchMember() async {
    member = await memberController.getMemberById(widget.username);
    posts = await postController.listPostsInterest(widget.username.toString());
    imageUser = member?.image.toString();
    int i = 0;
    while (i < posts!.length) {
      String ifvote = await voteController.getIFVoteChoice(
          widget.username, posts![i].postId.toString());
      if (ifvote != "0") {
        posts!.removeAt(i);
      } else {
        i++;
      }
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMember();
    selectedChoice = 0;

    widgets = [
      MemberScreen(username: widget.username),
      SearchPostScreen(username: widget.username),
      ListPostScreen(username: widget.username),
      NotifyPostScreen(username: widget.username),
      AddPostScreen(username: widget.username),
      ViewProfileScreen(
        username: widget.username,
      ),
      ChackPointScreen(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoaded == true
        ? Scaffold(
            drawer: Drawer(
            backgroundColor: MainColor,
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return LoginMemberScreen();
                    },
                  ));
                },
                icon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MainColor2,
                  ),
                  child: Icon(
                    Icons.login,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
          
            ),
            
            appBar: AppBar(
              backgroundColor: MainColor,
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              ),
              centerTitle: true,
              actions: <Widget>[
                ClipOval(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return widgets[5];
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SecondColor,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          baseURL + '/members/downloadimg/${imageUser}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: MainColor,
              onPressed: () {
                Widget destinationWidget;
                if ((member?.point ?? 0) >= 100) {
                  destinationWidget = widgets[4];
                } else {
                  destinationWidget = widgets[6];
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return destinationWidget;
                    },
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              shape: CircularNotchedRectangle(),
              notchMargin: 12,
              child: Container(
                height: 60,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedChoice = 0;
                            });
                          },
                          icon: Icon(Icons.home),
                          iconSize: 30,
                          color: (selectedChoice == 0)
                              ? MainColor
                              : Colors.blueGrey.withOpacity(0.6),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedChoice = 1;
                            });
                          },
                          icon: Icon(Icons.search),
                          iconSize: 30,
                          color: (selectedChoice == 1)
                              ? MainColor
                              : Colors.blueGrey.withOpacity(0.6),
                        ),
                        SizedBox(width: 60.0),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedChoice = 2;
                            });
                          },
                          icon: Icon(Icons.list_alt),
                          iconSize: 30,
                          color: (selectedChoice == 2)
                              ? MainColor
                              : Colors.blueGrey.withOpacity(0.6),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedChoice = 3;
                            });
                          },
                          icon: MyNotificationWidget(
                            selectedChoice: selectedChoice,
                            notificationCount: posts!.length,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            body: widgets[selectedChoice],
          )
        : Center(child: CircularProgressIndicator());
  }
}
