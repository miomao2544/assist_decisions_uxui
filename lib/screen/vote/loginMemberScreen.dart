import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/screen/vote/registerScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import '../validators/validatorLogin.dart';
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
  Future doLoginMember() async {
    result = await memberController.doLoginMember(username, password);
    print("-----------$result------------");
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
                Image.asset(
                  "assets/images/logo.png",
                  width: 250,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'แพลตฟอร์มสนับสนุนการตัดสินใจ',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: MainColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 300,
                  child: TextFormField(
                    style: TextStyle(color: MainColor, fontSize: 20.0),
                    decoration: InputDecoration(
                      labelText: 'ชื่อผู้ใช้งาน',
                      labelStyle: TextStyle(color: MainColor),
                      prefixIcon: Icon(Icons.person, color: MainColor),
                    ),
                    onChanged: (value) {
                      setState(() {
                        username = value;
                        doLoginMember();
                      });
                    },
                    validator:(value) => validateUsername(value,result),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 300,
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(color: MainColor, fontSize: 20.0),
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      labelStyle: TextStyle(color: MainColor),
                      prefixIcon: Icon(Icons.key, color: MainColor),
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        doLoginMember();
                      });
                    },
                    validator:(value) => validatePassword(value ,result),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      label:
                          Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            MainColor), // กำหนดสีพื้นหลังของปุ่ม
                      ),
                      onPressed: () async {
                        if (fromKey.currentState!.validate()) {
                          doLoginMember();
                          if (result == "true") {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return HomeScreen(username: username);
                            }));
                          } else if (result == "noactive") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('คุณโดนแบน'),
                                  content: Text('คุณโดนแบน'),
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
                          print("-------$result----------");
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label:
                          Text("สมัครสมาชิก", style: TextStyle(fontSize: 20)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            SecondColor), // กำหนดสีพื้นหลังของปุ่ม
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RegisterScreen();
                        }));
                      },
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
