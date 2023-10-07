import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math' as math;

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.notifications, size: 50),
        SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Thank you for registering!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Hatched will be coming to your region soon. Please allow notifications from hatched to receive an alert when the experience is ready.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 25),
        Container(
          width: 300,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              shape: BoxShape.rectangle,
              border: Border.all(width: 3.5, color: Colors.transparent),
              gradient: const LinearGradient(
                transform: GradientRotation(math.pi / 4),
                colors: [
                  Color(0xff7301E4),
                  Color(0xff0E8BFF),
                  Color(0xff09CBC8),
                  Color(0xff33D15F),
                ],
              )),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                shape: BoxShape.rectangle,
                color: Colors.white),
            child: CupertinoButton(
                onPressed: () async {
                  requestNotificationPermission();
                },
                child: const Text(
                  'Enable push notifications',
                  style: TextStyle(color: Colors.black),
                )),
          ),
        )
      ],
    ));
  }
}
