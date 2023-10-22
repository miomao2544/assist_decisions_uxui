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
        member = await memberController.getMemberById(widget.username);
    print("-------------------interest------------------${member}");
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
            remainingPoints = 100 - (member?.point ?? 0); 
      isDataLoaded = true;
    });
  }

    int? remainingPoints;


  Future ShowPointDrialog() => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
              content: Container(
                width: 280,
                height: 480,
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png",width: 250,),
                    Text("คะแนนไม่เพียงพอ", style: TextStyle(fontSize: 25.0,fontFamily: 'Light'),),
                    SizedBox(height: 10,),
                    Text("คะแนนของคุณคือ",style: TextStyle(fontFamily: 'Light'),),
                    SizedBox(height: 10,),
                    Text("${member?.point.toString()}", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Text("ต้องการคะแนนอีก ${remainingPoints} คะแนน \n จึงจะสามารถสร้างโพสต์ได้", textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Light',),),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ตกลง",style: TextStyle(fontFamily: 'Light'),),
                       style: ElevatedButton.styleFrom(
                      primary: MainColor,
                    ),
                    ),
                    
                  ],
                ),
              ),
            );
            },
          ); 

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: MainColor,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/6877208.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
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
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: SecondColor.withOpacity(0.8),
                                  width: 4,

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
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${member!.nickname.toString()}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                 fontFamily: 'Light'
                              ),
                            ),
                            Text(
                              '${member!.firstname.toString()} ${member!.lastname.toString()}',
                              style: TextStyle(
                                fontSize: 14.0,
                       
                                color: Colors.white,
                               fontFamily: 'Light'
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
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
                        
                          ),
                          child: Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: MainColor,
              onPressed: () {
                if ((member?.point ?? 0) >= 100) {
                 Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return widgets[4];
                            },
                          )); 
                } else {
                  ShowPointDrialog();
                }
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
