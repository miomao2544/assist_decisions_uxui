import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/screen/vote/editProfileScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:assist_decisions_app/widgets/divider_box.dart';
import 'package:flutter/material.dart';

import '../../constant/constant_value.dart';
import '../../controller/interestController.dart';
import '../../model/interest.dart';
import '../../model/member.dart';
import '../../widgets/InfoRow.dart';

class ViewProfileScreen extends StatefulWidget {
  final String username;
  const ViewProfileScreen({required this.username});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Member? member;
  bool? isDataLoaded = false;
  List<Interest> interests = [];
  List<String?> interestSelect = [];
  final MemberController memberController = MemberController();
  final InterestController interestController = InterestController();

  void fetchMember() async {
    member = await memberController.getMemberById(widget.username);
    if (member != null) {
      if (member!.interests != null) {
        interestSelect = member!.interests!
            .map((interest) => interest.interestName ?? "")
            .toList();
      }
      interests = member!.interests!;
      ;
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  String maskPassword(String password) {
    return '*' * password.length;
  }

  @override
  void initState() {
    super.initState();
    fetchMember();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor,
        title: Text('ข้อมูลส่วนตัว'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isDataLoaded == true
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SecondColor, 
                          width: 4.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          baseURL + '/members/downloadimg/${member?.image}',
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${member?.nickname}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "คะแนน",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("${member?.point}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("สถานะ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("${member?.status}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InfoRow(label: "เพศ", value: "${member?.gender == "M"? "ชาย":"หญิง"}"),
                    DividerBoxBlack(),
                    InfoRow(label: "ชื่อ", value: "${member?.firstname}"),
                    DividerBoxBlack(),
                    InfoRow(label: "นามสกุล", value: "${member?.lastname}"),
                    DividerBoxBlack(),
                    InfoRow(label: "อีเมล", value: "${member?.email}"),
                    DividerBoxBlack(),
                    InfoRow(label: "เบอร์โทรศัพท์", value: "${member?.tel}"),
                    DividerBoxBlack(),
                    SizedBox(height: 5,),
                    InfoRow(label: "สิ่งที่สนใจ", value: ""),
                    SizedBox(height: 5,),
                    Container(
                      height: 35.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: interests.length,
                        itemBuilder: (BuildContext context, int index) {
                          final interest = interests[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                
                                  color: MainColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                child: Text(
                                  interest.interestName ?? "",
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    InfoRow(
                        label: "ชื่อผู้ใช้งาน", value: "${member?.username}"),
                    DividerBoxBlack(),
                    SizedBox(height: 20),
                    Container(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(username: widget.username)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: MainColor, // เปลี่ยนสีปุ่มเป็นสีฟ้า
                        ),
                        child: Text("แก้ไขข้อมูล",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                ),
              ),
            )
          : CircularProgressIndicator(),
    ));
  }
}
