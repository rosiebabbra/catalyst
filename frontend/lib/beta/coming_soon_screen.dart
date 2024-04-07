import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math' as math;

import 'package:catalyst/utils/text_fade.dart';

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
        const FadeInText(
          child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: Icon(Icons.notifications_outlined, size: 50)),
        ),
        const SizedBox(height: 15),
        const FadeInText(
          delayStart: Duration(seconds: 1),
          animationDuration: Duration(seconds: 1),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Enable notifications",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        FadeInText(
            delayStart: const Duration(milliseconds: 2500),
            animationDuration: const Duration(milliseconds: 1200),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Text(
                  "catalyst will be available in your region soon. Please enable notifications to receive an alert as soon as it's ready.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            )),
        const SizedBox(height: 40),
        FadeInText(
          delayStart: const Duration(seconds: 4),
          child: Container(
            width: 300,
            height: 55,
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
                    // Push to coming soon page
                    Navigator.pushNamed(context, '/see-you-soon');
                  },
                  child: const Text(
                    'Enable notifications',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  )),
            ),
          ),
        )
      ],
    ));
  }
}
