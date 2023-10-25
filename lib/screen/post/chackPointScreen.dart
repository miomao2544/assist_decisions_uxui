import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

import '../../classcontroller/memberController.dart';
import '../../model/member.dart';

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
  }
}
