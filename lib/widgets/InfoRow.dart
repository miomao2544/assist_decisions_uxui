import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 17,color: MainColor,fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
