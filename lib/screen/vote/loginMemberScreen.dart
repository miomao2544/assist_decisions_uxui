import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/screen/vote/registerScreen.dart';
import 'package:flutter/material.dart';

class LoginMemberScreen extends StatefulWidget {
  const LoginMemberScreen({super.key});

  @override
  State<LoginMemberScreen> createState() => _LoginMemberScreenState();
}

class _LoginMemberScreenState extends State<LoginMemberScreen> {
  String username = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Register/login"),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
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
              SizedBox(height: 60.0),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Color.fromARGB(255, 30, 97, 66),
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                style: TextStyle(color: Color(0xFF1c174d), fontSize: 20.0),
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้ใช้งาน',
                  labelStyle: TextStyle(color: Color(0xFF1c174d)),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF1c174d)),
                ),
                onChanged: (value) {
                  setState(() {
                    username = value; // อัปเดตค่า username ทุกครั้งที่ผู้ใช้ป้อนข้อมูล
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                style: TextStyle(color: Color(0xFF1c174d), fontSize: 20.0),
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  labelStyle: TextStyle(color: Color(0xFF1c174d)),
                  prefixIcon: Icon(Icons.key, color: Color(0xFF1c174d)),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 20)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF479f76)), // กำหนดสีพื้นหลังของปุ่ม
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomeScreen(username: username);
                      }));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text("สมัครสมาชิก", style: TextStyle(fontSize: 20)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFe6a53b)), // กำหนดสีพื้นหลังของปุ่ม
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
    );
  }
}
