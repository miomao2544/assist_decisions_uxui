import 'package:assist_decisions_app/screen/addPostScreen.dart';
import 'package:assist_decisions_app/screen/listPostScreen.dart';
import 'package:assist_decisions_app/screen/loginMemberScreen.dart';
import 'package:assist_decisions_app/screen/memberScreen.dart';
import 'package:assist_decisions_app/screen/notifyPostScreen.dart';
import 'package:assist_decisions_app/screen/viewProfileScreen.dart';
import 'package:assist_decisions_app/widgets/myNotificationWidget%20.dart';
import 'package:flutter/material.dart';

import '../constant/constant_value.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedChoice = 0;
  int currentState = 0;

  List<Widget> widgets = [
    MemberScreen(),
    Text("null"),
    ListPostScreen(),
    NotifyPostScreen(),
    AddPostScreen(),
    ViewProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    selectedChoice = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("@username"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.ac_unit),
                  label: Text("ออกจากระบบ", style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFe6a53b)), // กำหนดสีพื้นหลังของปุ่ม
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginMemberScreen();
                    }));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Home Page"),
        centerTitle: true,
        actions: <Widget>[
          ClipOval(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const ViewProfileScreen();
                    },
                  ),
                );
              },
              child: Container(
                width: 55, // Set the width and height to be equal
                // Set the width and height to be equal
                child: Image.network(
                  baseURL + '/members/downloadimg/1691916492868.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const AddPostScreen();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
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
                    color: (selectedChoice == 0) ? Colors.amber : Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedChoice = 1;
                      });
                    },
                    icon: Icon(Icons.search),
                    iconSize: 30,
                    color: (selectedChoice == 1) ? Colors.amber : Colors.white,
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
                    color: (selectedChoice == 2) ? Colors.amber : Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedChoice = 3;
                      });
                    },
                    icon: MyNotificationWidget(selectedChoice:selectedChoice,notificationCount: 5,),
                  ),
                  
                ]),
          ),
        ),
      ),
      body: widgets[selectedChoice],
    );
  }
}
