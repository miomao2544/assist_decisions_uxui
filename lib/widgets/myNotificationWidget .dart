import 'package:flutter/material.dart';

class MyNotificationWidget extends StatelessWidget {
  final int selectedChoice;
  final int notificationCount;

  MyNotificationWidget({required this.selectedChoice, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return  Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 30,
            color: (selectedChoice == 3) ? Colors.amber : Colors.white,
          ),
          if (notificationCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  '$notificationCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
  }
}

