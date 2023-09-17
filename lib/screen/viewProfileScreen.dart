import 'package:assist_decisions_app/controller/member_controller.dart';
import 'package:assist_decisions_app/screen/editProfileScreen.dart';
import 'package:assist_decisions_app/widgets/divider_box.dart';
import 'package:flutter/material.dart';

import '../constant/constant_value.dart';
import '../controller/interest_controller.dart';
import '../model/interest.dart';
import '../model/member.dart';
import '../widgets/InfoRow.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Member? member;
  bool? isDataLoaded = false;
  List<bool> isSelected = [false, false, false];
  List<Interest> interests = [];
  List<String?> interestSelect = [];
  final MemberController memberController = MemberController();
  InterestController interestController = InterestController();

  void fetchMember() async {
    member = await memberController.getMemberById("maihom2001");
    print(member?.firstname);

    setState(() {
      isDataLoaded = true;
    });
  }

  String genderToText(String gender) {
    return gender == "M" ? "ชาย" : "หญิง";
  }

  String maskPassword(String password) {
    return '*' * password.length;
  }

  Future<void> loadInterests() async {
    List<Interest> interestList = await interestController.listAllInterests();
    setState(() {
      interests = interestList;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMember();
    loadInterests();
    isSelected = List<bool>.filled(interests.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            child: Column(children: [
              ClipOval(
                child: Image.network(
                  baseURL + '/members/downloadimg/${member?.image}',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${member?.nickname}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("สถานะ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("${member?.status}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              InfoRow(label: "คะแนน", value: "${member?.point}"),
              DividerBoxBlack(),
              InfoRow(label: "ชื่อ", value: "${member?.firstname}"),
              DividerBoxBlack(),
              InfoRow(label: "นามสกุล", value: "${member?.lastname}"),
              DividerBoxBlack(),
              InfoRow(label: "อีเมล", value: "${member?.email}"),
              DividerBoxBlack(),
              InfoRow(label: "เบอร์โทรศัพท์", value: "${member?.tel}"),
              DividerBoxBlack(),
              InfoRow(
                  label: "สิ่งที่สนใจ",
                  value: "${member?.interest?.interestName}"),
              DividerBoxBlack(),
              Container(
                height: 30.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: interests.length,
                  itemBuilder: (BuildContext context, int index) {
                    final interest = interests[index];
                    final isSelected =
                        interestSelect.contains(interest.interestId);
      
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              interestSelect.remove(interest.interestId);
                            } else {
                              interestSelect.add(interest.interestId);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                              isSelected ? Color(0xFF479f76) : Color(0xFF1c174d),
                        ),
                        child: Text(interest.interestName ?? ""),
                      ),
                    );
                  },
                ),
              ),
              Text("คุณสามารถเลือกความสนใจได้มากกว่า 1 อัน",
                  style: TextStyle(fontSize: 15)),
              InfoRow(label: "ชื่อผู้ใช้งาน", value: "${member?.username}"),
              DividerBoxBlack(),
              InfoRow(
                  label: "รหัสผ่าน", value: maskPassword(member?.password ?? "")),
              DividerBoxBlack(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>EditProfileScreen(member: member)),);
                },
                child: Text("แก้ไขข้อมูล"),
              ),
            ]),
          ),
        ),
      ),
    ));
  }
}
