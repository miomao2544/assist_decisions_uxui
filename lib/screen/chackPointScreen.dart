import 'package:flutter/material.dart';

import '../controller/member_controller.dart';
import '../model/member.dart';

class ChackPointScreen extends StatefulWidget {
  final String username;
  const ChackPointScreen({required  this.username});

  @override
  State<ChackPointScreen> createState() => _ChackPointScreenState();
}

class _ChackPointScreenState extends State<ChackPointScreen> {
    Member? member;
    int? remainingPoints;
 bool? isDataLoaded = false;
   final MemberController memberController = MemberController();
  void fetchMember() async {
    member = await memberController.getMemberById(widget.username);
    print("-------------------interest------------------${member}");

    setState(() {
      remainingPoints = 100 - (member?.point ?? 0); 
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMember();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
              content: Container(
                width: 280,
                height: 480,
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png",width: 250,),
                    Text("คะแนนไม่เพียงพอ", style: TextStyle(fontSize: 25.0),),
                    SizedBox(height: 10,),
                    Text("คะแนนของคุณคือ"),
                    SizedBox(height: 10,),
                    Text("${member?.point.toString()}", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Text("ต้องการคะแนนอีก ${remainingPoints} คะแนน \n จึงจะสามารถสร้างโพสต์ได้", textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for the "ตกลง" button here
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text("ตกลง"),
                       style: ElevatedButton.styleFrom(
                      primary: Colors.amber, // Set the button color
                    ),
                    ),
                    
                  ],
                ),
              ),
            );
  }
}
