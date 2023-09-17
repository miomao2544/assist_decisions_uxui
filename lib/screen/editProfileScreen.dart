import 'package:assist_decisions_app/controller/member_controller.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/loginMemberScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../controller/interest_controller.dart';
import '../model/interest.dart';

class EditProfileScreen extends StatefulWidget {
  final Member? member;
  const EditProfileScreen({required this.member});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final MemberController memberController = MemberController();
  InterestController interestController = InterestController();

  List<Interest> interests = [];
  String? selectedInterest;
  List<String?> interestSelect = [];
  List<bool> isSelected = [false, false, false];

  String? username = "";
  String? password = "";
  String? confirmPassword = "";
  String? nickname = "";
  String? gender = "";
  String? firstname = "";
  String? lastname = "";
  String? email = "";
  String? tel = "";
  TextEditingController memberImageTextController = TextEditingController();

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  FilePickerResult? filePickerResult;
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  bool isLoadingPicture = true;

  void _pickFile() async {
    try {
      setState(() {
        isLoadingPicture = true;
      });
      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      if (filePickerResult != null) {
        fileName = filePickerResult!.files.first.name;
        pickedFile = filePickerResult!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());
        memberImageTextController.text = fileName.toString();
        print("File is ${fileName}");
      }
      setState(() {
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
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
    loadInterests();
    isSelected = List<bool>.filled(interests.length, false);
    username = widget.member?.username;
    password = widget.member?.password;
    nickname = widget.member?.nickname;
    gender = widget.member?.gender;
    firstname = widget.member?.firstname;
    lastname = widget.member?.lastname;
    email = widget.member?.email;
    tel = widget.member?.tel;
    memberImageTextController = TextEditingController(text: widget.member?.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: fromKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 100,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'แพลตฟอร์มสนับสนุนการตัดสินใจ',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ส่วนของข้อมูลส่วนตัว',
                        ),
                      ),
                      Text('เพศ'),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                gender = 'M';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: gender == 'M'
                                  ? Color(0xFF479f76)
                                  : Color(0xFF1c174d),
                            ),
                            child: Text('ชาย'),
                          ),
                          SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                gender = 'F';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: gender == 'F'
                                  ? Color(0xFF479f76)
                                  : Color(0xFF1c174d),
                            ),
                            child: Text('หญิง'),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: firstname,
                        decoration: InputDecoration(
                          labelText: 'ชื่อ',
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            firstname = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: lastname,
                        decoration: InputDecoration(
                          labelText: 'นามสกุล',
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            lastname = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: email,
                        decoration: InputDecoration(
                          labelText: 'อีเมล์',
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: tel,
                        decoration: InputDecoration(
                          labelText: 'เบอร์โทร',
                          prefixIcon:
                              Icon(Icons.phone, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            tel = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text('ความสนใจ'),
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
                                      interestSelect
                                          .remove(interest.interestId);
                                    } else {
                                      interestSelect.add(interest.interestId);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: isSelected
                                      ? Color(0xFF479f76)
                                      : Color(0xFF1c174d),
                                ),
                                child: Text(interest.interestName ?? ""),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'สามารถเลือกได้มากกว่า 1 ตัวเลือก',
                        style:
                            TextStyle(fontSize: 16.0, color: Color(0xFF1c174d)),
                      ),
                      SizedBox(height: 20.0),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ส่วนของข้อมูลทั่วไป',
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Color(0xFF1c174d),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: isLoadingPicture
                            ? Image.asset(
                                "assets/images/logo.png",
                                width: 250,
                              ) // Add a loading indicator while loading the picture
                            : fileToDisplay != null
                                ? Image.file(
                                    fileToDisplay!,
                                    height: 200, // Set the desired image height
                                  )
                                : Container(), // Display an empty container if no image is selected
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _pickFile();
                          },
                          icon: Icon(Icons.image),
                          label: Text("เลือกรูปภาพ"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              isLoadingPicture
                                  ? Color(0xFF1c174d)
                                  : Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        initialValue: nickname,
                        decoration: InputDecoration(
                          labelText: 'ชื่อบัญชี',
                          prefixIcon: Icon(Icons.account_circle,
                              color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nickname = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: username,
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้งาน (ห้ามซ้ำ)',
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: password,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          prefixIcon: Icon(Icons.key, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'ยืนยันรหัสผ่าน',
                          prefixIcon: Icon(Icons.key, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              label:
                                  Text("บันทึก", style: TextStyle(fontSize: 20)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(Color(
                                        0xFF479f76)), // กำหนดสีพื้นหลังของปุ่ม
                              ),
                              onPressed: () async {
                                print("เพศ คือ : ${gender}");
                                if (fromKey.currentState!.validate()) {
                                  await memberController.updateMember(
                                    username ?? "",
                                    password ?? "",
                                    nickname ?? "",
                                    gender ?? "",
                                    firstname ?? "",
                                    lastname ?? "",
                                    email ?? "",
                                    tel ?? "",
                                    memberImageTextController.text,
                                    widget.member?.adminstatus.toString()??"",
                
                                  );
                                }
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginMemberScreen();
                                }));
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
