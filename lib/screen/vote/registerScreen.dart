import 'package:assist_decisions_app/controller/RegisterController.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../controller/interestController.dart';
import '../../controller/memberController.dart';
import '../../model/interest.dart';
import '../validators/validatorRegister.dart';
import 'loginMemberScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterController registerController = RegisterController();
  MemberController memberController = MemberController();
  InterestController interestController = InterestController();

  List<Interest> interests = [];

  List<String?> interestSelect = [];
  List<bool> isSelected = [false, false, false];

  String? username;
  String? password;
  String? confirmPassword;
  String? nickname;
  String? gender = "M";
  String? firstname;
  String? lastname;
  String? email;
  String? tel;
  String? formattedInterestSelect;
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

  bool isDataLoaded = false;
  Future loadInterests() async {
    List<Interest> interestList = await interestController.listAllInterests();
    setState(() {
      print(interests);
      interests = interestList;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadInterests().catchError((error) {
      print('Error loading interests: $error');
    });
    isSelected = List<bool>.filled(interests.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor,
        title: Text('สมัครสมาชิก',style: TextStyle(fontFamily: 'Light'),),
      ),
      body: isDataLoaded
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
                                  color: MainColor,fontFamily: 'Light'),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ส่วนของข้อมูลส่วนตัว',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold,fontFamily: 'Light'),
                            ),
                          ),
                          Text(
                            'เพศ',
                            style: TextStyle(
                                color: MainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,fontFamily: 'Light'),
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
                                child: Text('หญิง',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,fontFamily: 'Light')),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ชื่อ',
                              prefixIcon: Icon(Icons.person, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              setState(() {
                                firstname = value;
                              });
                            },
                            validator: validateFirstname,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'นามสกุล',
                              prefixIcon: Icon(Icons.person, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              setState(() {
                                lastname = value;
                              });
                            },
                            validator: validateLastname,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'อีเมล์',
                              prefixIcon: Icon(Icons.email, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: validateEmail,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'หมายเลขโทรศัพท์',
                              prefixIcon: Icon(Icons.phone, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              setState(() {
                                tel = value;
                              });
                            },
                            validator: validateTel,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'ความสนใจ',
                            style: TextStyle(
                                color: MainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,fontFamily: 'Light'),
                          ),
                          SizedBox(height: 4.0),
                          Container(
                            height: 38.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: interests.length,
                              itemBuilder: (BuildContext context, int index) {
                                final interest = interests[index];
                                final isSelected = interestSelect
                                    .contains(interest.interestId);
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isSelected) {
                                          interestSelect
                                              .remove(interest.interestId);
                                        } else {
                                          interestSelect
                                              .add(interest.interestId);
                                        }
                                        formattedInterestSelect = interestSelect
                                            .where((item) => item != null)
                                            .join(',');
                                        print(
                                            "interestSelect is ----------------- > = " +
                                                formattedInterestSelect
                                                    .toString());
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          isSelected ? SecondColor : MainColor,
                                    ),
                                    child: Text(
                                      interest.interestName ?? "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,fontFamily: 'Light'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            'สามารถเลือกได้มากกว่า 1 ตัวเลือก',
                            style: TextStyle(fontSize: 16.0, color: MainColor,fontFamily: 'Light'),
                          ),
                          SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ส่วนของข้อมูลทั่วไป',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  color: MainColor,
                                  fontWeight: FontWeight.bold,fontFamily: 'Light'),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                            child: isLoadingPicture
                                ? Image.asset(
                                    "assets/images/logo.png",
                                    width: 250,
                                  )
                                : fileToDisplay != null
                                    ? Image.file(
                                        fileToDisplay!,
                                        fit: BoxFit.cover,
                                        width: 200,
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
                              label: Text("เลือกรูปภาพ",style: TextStyle(fontFamily: 'Light'),),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isLoadingPicture ? MainColor : SecondColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ชื่อบัญชี',
                              prefixIcon:
                                  Icon(Icons.account_circle, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                                                         border: InputBorder.none,
                          filled: true,
                           fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              setState(() {
                                nickname = value;
                              });
                            },
                            validator: validateNickname,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ชื่อผู้ใช้งาน (ห้ามซ้ำ)',
                              prefixIcon:
                                  Icon(Icons.account_box, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
                                                         border: InputBorder.none,
                          filled: true,
                           fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              setState(() {
                                checkUsernameExists(value);
                                username = value;
                              });
                            },
                            validator: validateUsername,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'รหัสผ่าน',
                              prefixIcon: Icon(Icons.key, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
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
                            validator: validatePassword,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ยืนยันรหัสผ่าน',
                              prefixIcon:
                                  Icon(Icons.key_outlined, color: MainColor),
                              labelStyle: TextStyle(color: MainColor,fontFamily: 'Light'),
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
                            validator: (value) =>
                                validateConfirmPassword(value, password),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton.icon(
                                  icon: Icon(Icons.add),
                                  label: Text("สมัคร",
                                      style: TextStyle(fontSize: 20,fontFamily: 'Light')),
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
                                                  child: Text('ปิด'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        String? fileToSend = "I00001.png";
                                        if (fileToDisplay != null) {
                                          var uploadedFile =
                                              await memberController
                                                  .upload(fileToDisplay!);
                                          if (uploadedFile != null) {
                                            fileToSend = uploadedFile;
                                          }
                                        }
                                        if (isUsernameTaken == false) {
                                          var result =
                                              await registerController.doRegister(
                                                  username ?? "",
                                                  password ?? "",
                                                  nickname ?? "",
                                                  gender ?? "",
                                                  firstname ?? "",
                                                  lastname ?? "",
                                                  email ?? "",
                                                  tel ?? "",
                                                  fileToSend ?? "",
                                                  formattedInterestSelect ??
                                                      "");
                                          if (result != null) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('สำเร็จ'),
                                                  content: Text(
                                                      'บันทึกสมาชิกสำเร็จ'),
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
                                            Future.delayed(
                                                Duration(milliseconds: 1000),
                                                () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return LoginMemberScreen();
                                              }));
                                            });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('ข้อผิดพลาด'),
                                                  content: Text(
                                                      'บันทึกการสมัครของคุณไม่สำเร็จ'),
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
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('ข้อผิดพลาด'),
                                                content: Text(
                                                    'Username ของคุณมีในระบบแล้ว'),
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
          : Center(child: CircularProgressIndicator()),
    );
  }
}
