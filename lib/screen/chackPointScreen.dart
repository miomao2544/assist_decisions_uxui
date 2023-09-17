import 'package:flutter/material.dart';

class ChackPointScreen extends StatefulWidget {
  const ChackPointScreen({super.key});

  @override
  State<ChackPointScreen> createState() => _ChackPointScreenState();
}

class _ChackPointScreenState extends State<ChackPointScreen> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Show the image popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: 280,
                height: 480,
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png",width: 250,),
                    Text("คะแนนไม่เพียงพอ", style: TextStyle(fontSize: 25.0),),
                    SizedBox(height: 10,),
                    Text("คะแนนของคุณคือ"),
                    SizedBox(height: 10,),
                    Text("0", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Text("ต้องการคะแนนอีก 100 คะแนน \n จึงจะสามารถสร้างโพสต์ได้", textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for the "ตกลง" button here
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text("ตกลง"),
                       style: ElevatedButton.styleFrom(
                      primary: Colors.amber, // Set the button color
                    ),
                    ),
                    
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('ตัวอย่าง ChackPoint'),
      style: ElevatedButton.styleFrom(
      primary: Color.fromARGB(255, 255, 191, 0),
      ),
    );
  }
}
