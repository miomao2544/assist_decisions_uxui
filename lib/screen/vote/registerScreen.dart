import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/screen/vote/loginMemberScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../controller/interestController.dart';
import '../../model/interest.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final MemberController memberController = MemberController();
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

  Future checkUsernameExists(String username) async{
     isUsernameTaken = await memberController.checkUsernameExists(username);
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
        title: Text('Register'),
      ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อ';
                          } else if (!isThaiOrEnglish(value)) {
                            return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
                          } else if (value.length < 2 || value.length > 100) {
                            return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกนามสกุล';
                          } else if (!isThaiOrEnglish(value)) {
                            return 'กรุณาเขียนเป็นภาษาไทย หรือ อังกฤษเท่านั้น';
                          } else if (value.length < 2 || value.length > 100) {
                            return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกอีเมล์';
                          } else if (!isValidEmail(value)) {
                            return 'รูปแบบของคุณอีเมล์ไม่ถูกต้อง';
                          } else if (value.length < 5 || value.length > 60) {
                            return 'อักษรของคุณควรอยู่ระหว่าง 5 และ 60 ตัวอักษร';
                          } else if (value.contains(' ')) {
                            return 'ไม่อนุญาตให้มีช่องว่างในข้อมูล';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'หมายเลขโทรศัพท์',
                          prefixIcon:
                              Icon(Icons.phone, color: Color(0xFF1c174d)),
                          labelStyle: TextStyle(color: Color(0xFF1c174d)),
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
                                    formattedInterestSelect = interestSelect
                                        .where((item) => item != null)
                                        .join(',');
                                    print(
                                        "interestSelect is ----------------- > = " +
                                            formattedInterestSelect.toString());
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
                        decoration: InputDecoration(
                            labelText: 'ชื่อบัญชี',
                            prefixIcon: Icon(Icons.account_circle)),
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
                          } else if (value.length < 2 || value.length > 100) {
                            return 'อักษรของคุณควรอยู่ระหว่าง 2 และ 100 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้งาน (ห้ามซ้ำ)',
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อผู้ใช้งาน';
                          } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                              .hasMatch(value)) {
                            return 'กรุณากรอกตัวอักษรภาษาอังกฤษหรือตัวเลขเท่านั้น';
                          } else if (value.length < 6 || value.length > 12) {
                            return 'อักษรของคุณควรอยู่ระหว่าง 6 และ 12 ตัวอักษร';
                          }
                          checkUsernameExists(value);
                          if (isUsernameTaken) {
                            return 'ชื่อผู้ใช้งานนี้มีอยู่ในระบบแล้ว';
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          } else if (value.length < 8 || value.length > 16) {
                            return 'รหัสผ่านควรมีความยาวระหว่าง 8 และ 16 ตัวอักษร';
                          } else if (!RegExp(r'^[a-zA-Z0-9@_\-\.]+$')
                              .hasMatch(value)) {
                            return 'รหัสผ่านควรประกอบด้วยตัวอักษรภาษาอังกฤษ, ตัวเลข, @, _, -, หรือ . เท่านั้น';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'ยืนยันรหัสผ่าน',
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณารหัสผ่านอีกครั้งเพื่อยืนยัน';
                          } else if (value.toString() != password) {
                            return 'รหัสผ่านของคุณไม่เหมือนเดิม กรุณากรอกใหม่อีกครั้ง';
                          }
                          return null;
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
                                  Text("สมัคร", style: TextStyle(fontSize: 20)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(Color(
                                        0xFF479f76)), // กำหนดสีพื้นหลังของปุ่ม
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
                                    String? fileToSend =
                                        "I00001.png"; // เริ่มต้นให้ใช้ fileToDisplay

                                    if (fileToDisplay != null) {
                                      // รอผลลัพธ์จากการอัปโหลด
                                      var uploadedFile = await memberController
                                          .upload(fileToDisplay!);

                                      // ตรวจสอบว่า uploadedFile ไม่เป็น null
                                      if (uploadedFile != null) {
                                        fileToSend = uploadedFile;
                                      }
                                    }
                                    checkUsernameExists(username??"");
                                    if(isUsernameTaken == false){
                                    var result =
                                        await memberController.addMember(
                                            username ?? "",
                                            password ?? "",
                                            nickname ?? "",
                                            gender ?? "",
                                            firstname ?? "",
                                            lastname ?? "",
                                            email ?? "",
                                            tel ?? "",
                                            fileToSend ?? "",
                                            formattedInterestSelect ?? "");
                                    if (result != null) {
                                      // แสดงอนิเมชันแจ้งเตือนเมื่อสมัครสมาชิกสำเร็จ
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('สำเร็จ'),
                                            content: Text('บันทึกสมาชิกสำเร็จ'),
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
                                      Future.delayed(
                                          Duration(milliseconds: 1000), () {
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
                                            content: Text('ข้อมูลไม่ถูกต้อง'),
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
                                    }
                                    }else{
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('ข้อผิดพลาด'),
                                            content: Text('Username ของคุณมีในระบบแล้ว'),
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
          )),
    );
  }
}
