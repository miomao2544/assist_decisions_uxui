import 'package:assist_decisions_app/classcontroller/historyController.dart';
import 'package:assist_decisions_app/controller/LoginMemberController.dart';
import 'package:assist_decisions_app/classcontroller/memberController.dart';
import 'package:assist_decisions_app/model/historyBan.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/screen/vote/registerScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import '../validators/validatorLogin.dart';
import 'package:intl/intl.dart';

class LoginMemberScreen extends StatefulWidget {
  const LoginMemberScreen({super.key});

  @override
  State<LoginMemberScreen> createState() => _LoginMemberScreenState();
}

class _LoginMemberScreenState extends State<LoginMemberScreen> {
  String username = "";
  String password = "11111111";
  String? result;
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  MemberController memberController = MemberController();
  HistoryBanController historyBanController = HistoryBanController();

  LoginMemberController loginMemberController = LoginMemberController();
  Future doLoginMember() async {
    result = await loginMemberController.doLoginMember(username, password);
    print("-----------$result------------");
  }



String formatDate(String? inputDate,String?  dateBan) {
  if (inputDate != null) {
    final DateTime date = DateTime.parse(inputDate);
    final int? numberOfDay = int.tryParse(dateBan!);
    final DateTime newDate = date.add(Duration(days: numberOfDay??0));
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(newDate.toLocal());
  }
  return '';
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                Image.asset(
                  "assets/images/logo.png",
                  width: 150,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Assist Decisions',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: MainColor),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'แอปพลิเคชันสนับสนุนการตัดสินใจ',
                    style: TextStyle(fontSize: 22.0, fontFamily: 'Light'),
                  ),
                ),
                SizedBox(height: 40.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: MainColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Light'),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 350,
                  child: TextFormField(
                    key: Key('username'),
                    style: TextStyle(color: MainColor, fontSize: 20.0),
                    decoration: InputDecoration(
                      labelText: 'ชื่อผู้ใช้งาน',
                      labelStyle:
                          TextStyle(color: Colors.black, fontFamily: 'Light'),
                      prefixIcon: Icon(Icons.person, color: MainColor),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                    ),
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      
                      });
                    },
                    validator: (value) => validateUsername(value, result),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 350,
                  child: TextFormField(
                    key: Key('password'),
                    obscureText: true,
                    style: TextStyle(color: MainColor, fontSize: 20.0),
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      labelStyle:
                          TextStyle(color: Colors.black, fontFamily: 'Light'),
                      prefixIcon: Icon(Icons.key, color: MainColor),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                   
                      });
                    },
                    validator: (value) => validatePassword(value, result),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        doLoginMember();
                        if (fromKey.currentState!.validate()) {
                          doLoginMember();
                          if (result == "true") {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return HomeScreen(username: username);
                            }));
                          } else if (result == "noactive") {
                            HistoryBan historyBan = await historyBanController.getHistoryUser(username);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('คุณโดนแบน ${historyBan.banType!.typeName.toString()} จำนวน ${historyBan.banType!.numberOfDay.toString()} วัน'),
                                  content: Container(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text('${historyBan.banComment} '),
                                        Text('คุณถูกแบนถึงวันที่'),
                                        Text('${formatDate(historyBan.banDate,historyBan.banType!.numberOfDay.toString())}',style: TextStyle(fontSize: 25),),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(MainColor), // สีพื้นหลังของปุ่ม
                                      ),
                                      child: Text('ปิด'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (result == "") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('ไม่พบข้อมูล'),
                                  content: Text(
                                      'ไม่พบข้อมูลบัญชีนี้ กรุณาสมัครก่อนการเข้าสู่ระบบ'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(MainColor), // สีพื้นหลังของปุ่ม
                                      ),
                                      child: Text('ปิด'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          print("-------$result----------");
                        }
                      },
                      child: Text("เข้าสู่ระบบ",
                          style: TextStyle(fontSize: 22, fontFamily: 'Light')),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(MainColor),
                        // กำหนดสีพื้นหลังของปุ่ม
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegisterScreen();
                            },
                          ),
                        );
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            Color borderColor = MainColor; // กำหนดสีขอบ
                            return BorderSide(
                                color: borderColor,
                                width: 2); // กำหนดความกว้างของขอบ
                          },
                        ),
                      ),
                      child: Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Light',
                            color: MainColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
