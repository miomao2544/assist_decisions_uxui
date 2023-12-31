import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/EditProfileController.dart';
import 'package:assist_decisions_app/controller/LoginMemberController.dart';
import 'package:assist_decisions_app/classcontroller/memberController.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/screen/vote/ViewProfileScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../classcontroller/interestController.dart';
import '../../model/interest.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({required this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  LoginMemberController loginMemberController = LoginMemberController();
  EditProfileController editProfileController = EditProfileController();
  MemberController memberController = MemberController();
  InterestController interestController = InterestController();

  List<Interest> interests = [];

  List<String?> interestSelect = [];
  List<bool> isSelected = [false, false, false];

  String? username;
  String? password;
  String? confirmPassword;
  String? nickname;
  String? gender;
  String? firstname;
  String? lastname;
  String? email;
  String? tel;
  String? point;
  String? status;
  String? formattedInterestSelect;
  Member? member;
  TextEditingController memberImageTextController = TextEditingController();

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  FilePickerResult? filePickerResult;
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  bool isLoadingPicture = true;
  bool? isDataLoaded = false;
  bool isUsernameTaken = true;
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

  String result = "";

  Future doLoginMember() async {
    result = await loginMemberController.doLoginMember(
        widget.username.toString(), password.toString());
    print("-----------$result------------");
  }

  Future loadInterests() async {
    List<Interest> interestList = await interestController.listAllInterests();
    setState(() {
      print(interests);
      interests = interestList;
    });
  }

  bool isThaiOrEnglish(String input) {
    final thaiPattern = RegExp(r'^[ก-๏\s]+$');
    final englishPattern = RegExp(r'^[a-zA-Z\s]+$');

    return thaiPattern.hasMatch(input) || englishPattern.hasMatch(input);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    loadInterests();
    isSelected = List<bool>.filled(interests.length, false);
  }

  Future<void> initializeData() async {
    member =
        await editProfileController.doProfileDetail(widget.username.toString());
    if (member != null) {
      firstname = member?.firstname.toString();
      username = member?.username.toString();
      nickname = member?.nickname.toString();
      gender = member?.gender.toString();
      password = member?.password.toString();
      lastname = member?.lastname.toString();
      email = member?.email.toString();
      tel = member?.tel.toString();
      point = member?.point.toString();
      status = member?.status.toString();
      interestSelect = member!.interests!
          .map((interest) => interest.interestId.toString())
          .toList();
      formattedInterestSelect =
          interestSelect.where((item) => item != null).join(',');
      print("object>>>>> ${formattedInterestSelect}");
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeData();
    gender = member?.gender.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor,
        title: Text(
          'แก้ไข',
          style: TextStyle(fontFamily: 'Light'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isDataLoaded == true
          ? Padding(
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
                              'แอปพลิเคชันสนับสนุนการตัดสินใจ',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: MainColor,
                                  fontFamily: 'Light'),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ส่วนของข้อมูลส่วนตัว',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Light'),
                            ),
                          ),
                          Text(
                            'เพศ',
                            style: TextStyle(
                                color: MainColor,
                                fontSize: 16,
                                fontFamily: 'Light'),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    gender = 'M';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      gender == 'M' ? SecondColor : MainColor,
                                ),
                                child: Text(
                                  'ชาย',
                                  style: TextStyle(fontFamily: 'Light'),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    gender = 'F';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      gender == 'F' ? SecondColor : MainColor,
                                ),
                                child: Text(
                                  'หญิง',
                                  style: TextStyle(fontFamily: 'Light'),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: TextFormField(
                              key: Key('firstname'),
                              initialValue: firstname,
                              decoration: InputDecoration(
                                labelText: 'ชื่อ',
                                prefixIcon:
                                    Icon(Icons.person, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  firstname = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกชื่อ';
                                } else if (!isThaiOrEnglish(value)) {
                                  return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
                                } else if (value.length < 2 ||
                                    value.length > 100) {
                                  return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: TextFormField(
                              key: Key('lastname'),
                              initialValue: lastname,
                              decoration: InputDecoration(
                                labelText: 'นามสกุล',
                                prefixIcon:
                                    Icon(Icons.person, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  lastname = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกนามสกุล';
                                } else if (!isThaiOrEnglish(value)) {
                                  return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
                                } else if (value.length < 2 ||
                                    value.length > 100) {
                                  return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: TextFormField(
                              key: Key('email'),
                              initialValue: email,
                              decoration: InputDecoration(
                                labelText: 'อีเมล์',
                                prefixIcon: Icon(Icons.email, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกอีเมล์';
                                } else if (!isValidEmail(value)) {
                                  return 'รูปแบบของคุณอีเมล์ไม่ถูกต้อง';
                                } else if (value.length < 5 ||
                                    value.length > 60) {
                                  return 'อักษรของคุณควรอยู่ระหว่าง 5 และ 60 ตัวอักษร';
                                } else if (value.contains(' ')) {
                                  return 'ไม่อนุญาตให้มีช่องว่างในข้อมูล';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: TextFormField(
                              key: Key('tel'),
                              initialValue: tel,
                              decoration: InputDecoration(
                                labelText: 'หมายเลขโทรศัพท์',
                                prefixIcon: Icon(Icons.phone, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  tel = value;
                                });
                              },
                              validator: (value) {
                                final validDigits = RegExp(r'^[0-9]{10}$');

                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกหมายเลขโทรศัพท์';
                                } else if (!value.startsWith('06') &&
                                    !value.startsWith('08') &&
                                    !value.startsWith('09')) {
                                  return 'หมายเลขโทรศัพท์ต้องขึ้นต้นด้วย 06, 08, หรือ 09';
                                }
                                if (!validDigits.hasMatch(value.toString())) {
                                  return 'หมายเลขโทรศัพท์ต้องประกอบด้วยตัวเลข 0-9';
                                } else if (value.length != 10) {
                                  return 'หมายเลขโทรศัพท์ต้องมี 10 ตัวเท่านั้น';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'ความสนใจ',
                            style: TextStyle(fontFamily: 'Light'),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'ความสนใจที่คุณอาจสนใจ',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Light'),
                                ),
                                Container(
                                  height: 30.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: interests.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final interest = interests[index];
                                      final isSelected = interestSelect
                                          .contains(interest.interestId);

                                      if (!isSelected) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (isSelected) {
                                                  interestSelect.remove(
                                                      interest.interestId);
                                                } else {
                                                  interestSelect
                                                      .add(interest.interestId);
                                                }
                                                formattedInterestSelect =
                                                    interestSelect
                                                        .where((item) =>
                                                            item != null)
                                                        .join(',');
                                                print(
                                                    "interestSelect is ----------------- > = " +
                                                        formattedInterestSelect
                                                            .toString());
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: isSelected
                                                  ? SecondColor
                                                  : MainColor,
                                            ),
                                            child: Text(
                                              interest.interestName ?? "",
                                              style: TextStyle(
                                                  fontFamily: 'Light'),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'ความสนใจของคุณ',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Light'),
                                ),
                                Container(
                                  height: 30.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: interests.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final interest = interests[index];
                                      final isSelected = interestSelect
                                          .contains(interest.interestId);

                                      if (isSelected) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (isSelected) {
                                                  interestSelect.remove(
                                                      interest.interestId);
                                                  // Remove from formattedInterestSelect
                                                  formattedInterestSelect =
                                                      interestSelect
                                                          .where((item) =>
                                                              item != null)
                                                          .join(',');
                                                } else {
                                                  if (!interestSelect.contains(
                                                      interest.interestId)) {
                                                    interestSelect.add(
                                                        interest.interestId);
                                                    formattedInterestSelect =
                                                        interestSelect
                                                            .where((item) =>
                                                                item != null)
                                                            .join(',');
                                                  }
                                                }

                                                print(
                                                    "interestSelect is ----------------- > = " +
                                                        formattedInterestSelect
                                                            .toString());
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: isSelected
                                                  ? SecondColor
                                                  : MainColor,
                                            ),
                                            child: Text(
                                              interest.interestName ?? "",
                                              style: TextStyle(
                                                  fontFamily: 'Light'),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            'สามารถเลือกได้มากกว่า 1 ตัวเลือก',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: MainColor,
                                fontFamily: 'Light'),
                          ),
                          SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ส่วนของข้อมูลทั่วไป',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Light'),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Center(
                            child: isLoadingPicture
                                ? Image.network(
                                    baseURL +
                                        '/members/downloadimg/${member!.image}',
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : fileToDisplay != null
                                    ? Image.file(
                                        fileToDisplay!,
                                        height: 200,
                                      )
                                    : Container(),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _pickFile();
                              },
                              icon: Icon(Icons.image),
                              label: Text(
                                "เลือกรูปภาพ",
                                style: TextStyle(fontFamily: 'Light'),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isLoadingPicture ? MainColor : SecondColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            child: TextFormField(
                              key: Key('nickname'),
                              initialValue: nickname,
                              decoration: InputDecoration(
                                labelText: 'ชื่อบัญชี',
                                prefixIcon: Icon(Icons.account_circle,
                                    color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  nickname = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกชื่อ';
                                } else if (!isThaiOrEnglish(value)) {
                                  return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
                                } else if (value.length < 2 ||
                                    value.length > 100) {
                                  return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: TextFormField(
                              key: Key('username'),
                              initialValue: username,
                              decoration: InputDecoration(
                                labelText: 'ชื่อผู้ใช้งาน (ห้ามซ้ำ)',
                                prefixIcon:
                                    Icon(Icons.account_box, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              enabled: false,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: TextFormField(
                              key: Key('password'),
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
                                prefixIcon: Icon(Icons.key, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              validator: (value) {
                  
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8 ||
                                    value.length > 16) {
                                  return 'รหัสผ่านควรมีความยาวระหว่าง 8 และ 16 ตัวอักษร';
                                } else if (!RegExp(r'^[a-zA-Z0-9@_\-\.]+$')
                                    .hasMatch(value)) {
                                  return 'รหัสผ่านควรประกอบด้วยตัวอักษรภาษาอังกฤษ, ตัวเลข, @, _, -, หรือ . เท่านั้น';
                                }
                                return null;
                       
                              },
                            ),
                          ),
                                                                         Text(
                            'กรอกเมื่อต้องการเปลี่ยนรหัสผ่าน',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: MainColor,
                                fontFamily: 'Light'),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            child: TextFormField(
                              key: Key('confirmPassword'),
                              decoration: InputDecoration(
                                labelText: 'ยืนยันรหัสผ่าน',
                                prefixIcon: Icon(Icons.key, color: MainColor),
                                labelStyle: TextStyle(
                                    color: MainColor, fontFamily: 'Light'),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  confirmPassword = value;
                                });
                              },
                              validator: (value) {
                                 if (value == null || value.isEmpty) {
                                  return null;
                                }
                                if (value.toString() != password) {
                                  return 'รหัสผ่านของคุณไม่เหมือนเดิม กรุณากรอกใหม่อีกครั้ง';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton.icon(
                                  icon: Icon(Icons.add),
                                  label: Text("บันทึกข้อมูล",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Light')),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        MainColor), // กำหนดสีพื้นหลังของปุ่ม
                                  ),
                                  onPressed: () async {
                                    if (fromKey.currentState!.validate()) {
                                      if (interestSelect.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              Navigator.of(context).pop();
                                            });

                                            return AlertDialog(
                                              title: Text('แจ้งเตือน'),
                                              content: Text(
                                                  'กรุณาเลือกความสนใจอย่างน้อย 1 ตัวเลือก'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            MainColor), // สีพื้นหลังของปุ่ม
                                                  ),
                                                  child: Text('ปิด'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        doLoginMember();
                                        String? fileToSend = member?.image
                                            .toString(); // เริ่มต้นให้ใช้ fileToDisplay

                                        if (fileToDisplay != null) {
                                          // รอผลลัพธ์จากการอัปโหลด
                                          var uploadedFile =
                                              await memberController
                                                  .upload(fileToDisplay!);

                                          // ตรวจสอบว่า uploadedFile ไม่เป็น null
                                          if (uploadedFile != null) {
                                            fileToSend = uploadedFile;
                                          }
                                        }

                                        print("---------- result------------");
                                        print(username);
                                        print(password!.isEmpty?"pass":password!);
                                        print(nickname);
                                        print(gender);
                                        print(firstname);
                                        print(lastname);
                                        print(email);
                                        print(tel);
                                        print(point);
                                        print(status);
                                        print(fileToSend);
                                        print(formattedInterestSelect);
                                        var result = await editProfileController
                                            .doEditProfile(
                                                username ?? "",
                                                password??"",
                                                nickname ?? "",
                                                gender ?? "",
                                                firstname ?? "",
                                                lastname ?? "",
                                                email ?? "",
                                                tel ?? "",
                                                point ?? "",
                                                status ?? "",
                                                fileToSend ?? "",
                                                formattedInterestSelect ?? "");
                                        if (result != null) {
                                          // แสดงอนิเมชันแจ้งเตือนเมื่อสมัครสมาชิกสำเร็จ
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('สำเร็จ'),
                                                content: Text(
                                                    'บันทึกการเปลี่ยนแปลงสำเร็จ'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return ViewProfileScreen(
                                                              username: widget
                                                                  .username
                                                                  .toString(),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Text('ปิด'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          Future.delayed(
                                              Duration(milliseconds: 1000), () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ViewProfileScreen(
                                                  username: widget.username
                                                      .toString());
                                            }));
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('ข้อผิดพลาด'),
                                                content:
                                                    Text('ข้อมูลไม่ถูกต้อง'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('ปิด'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
          : CircularProgressIndicator(),
    );
  }
}
