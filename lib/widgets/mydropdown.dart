import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String point = "";
  List<String> numbers = ["0", "1000", "500", "200", "100", "50"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: point,
        items: numbers.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              point = newValue;
            });
          }
        },
      ),
    );
  }
}