import 'package:assist_decisions_app/controller/LoginAdminController.dart';
import 'package:assist_decisions_app/screen/admin/listReportScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

import '../validators/validatorLogin.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  String username = "";
  String password = "";
  String result = "";
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  LoginAdminController loginAdminController = LoginAdminController();

  Future doLoginAdmin() async {
    result = await loginAdminController.doLoginAdmin(username, password);
    print("-----------$result------------");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Container(
                    width: 400,
                    color: Colors.white,
                    child: Form(
                      key: fromKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(height: 30.0),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: MainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                            
                            child: TextFormField(
                              key: Key("username"),
                              style:
                                  TextStyle(color: MainColor, fontSize: 20.0),
                              decoration: InputDecoration(
                                labelText: 'ชื่อผู้ใช้งาน',
                        
                                labelStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Light'),
                                prefixIcon:
                                    Icon(Icons.person, color: MainColor),
                                border: InputBorder.none,
                                                      filled: true,
                      fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                         
                                });
                              },
                              validator: (value) =>
                                  validateUsername(value, result),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 300,
                        
                            child: TextFormField(
                              key: Key('password'),
                              obscureText: true,
                              style:
                                  TextStyle(color: MainColor, fontSize: 20.0),
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontFamily: 'Light'),
                                prefixIcon:
                                    Icon(Icons.person, color: MainColor),
                                border: InputBorder.none,
                                                      filled: true,
                      fillColor: Colors.blueGrey[50],
                              ),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                  
                                });
                              },
                              validator: (value) =>
                                  validatePassword(value, result),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 200,
                              height: 60,
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.login),
                                label: Text(
                                  "เข้าสู่ระบบ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    MainColor,
                                  ),
                                ),
                                onPressed: () {
                                  doLoginAdmin();
                                  if (fromKey.currentState!.validate()) {
                                    doLoginAdmin();
                                    if (result == "admin") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ListReportScreen(
                                          username: username,
                                        );
                                      }));
                                    }else if(result == "true"){
                                         showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('ข้อจำกัด'),
                                            content: Text('สิทธิของคุณเข้าไม่ถึงระบบนี้'),
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
                                     else{
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('ไม่มีข้อมูล'),
                                            content: Text('ไม่พบข้อมูลของคุณ'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(MainColor), 
                                            // สีพื้นหลังของปุ่ม
                                      ),
                                      
                                      
                                                child: Text('ปิด'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (MediaQuery.of(context).size.width >= 600)
                // ฝั่งขวา: Container ที่มีสีพื้นหลัง (แสดงเฉพาะเว็บ)
                Expanded(
                  child: Container(
                    color: Color.fromARGB(255, 250, 176, 10),
                    child: Image.asset(
                      "assets/images/bg01.png",
                      height: 1000,
                    ), // สีพื้นหลังที่คุณต้องการใช้
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
