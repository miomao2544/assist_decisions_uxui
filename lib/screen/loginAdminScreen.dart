import 'package:flutter/material.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
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
                            color: Color.fromARGB(255, 30, 97, 66),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        child: TextField(
                          style: TextStyle(
                            color: Color(0xFF1c174d),
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'ชื่อผู้ใช้งาน',
                            labelStyle: TextStyle(color: Color(0xFF1c174d)),
                            prefixIcon: Icon(Icons.person, color: Color(0xFF1c174d)),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: 400,
                        child: TextField(
                          obscureText: true,
                          style: TextStyle(
                            color: Color(0xFF1c174d),
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน',
                            labelStyle: TextStyle(color: Color(0xFF1c174d)),
                            prefixIcon: Icon(Icons.key, color: Color(0xFF1c174d)),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 16.0,
                            ),
                          ),
                        ),
                      ),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF479f76),
                              ),
                            ),
                            onPressed: () {},
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
                color: Color.fromARGB(255, 1, 51, 79), // สีพื้นหลังที่คุณต้องการใช้
              ),
            ),
        ],
      ),
    ),
  ),
);


  }
}
