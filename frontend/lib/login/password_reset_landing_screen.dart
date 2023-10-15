import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CountdownWidget extends StatefulWidget {
  final int seconds;

  const CountdownWidget({Key? key, required this.seconds}) : super(key: key);

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel(); // Stop the timer when countdown reaches 0
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Color(0xff33D15F),
      radius: 15,
      child: CircleAvatar(
        radius: 13,
        backgroundColor: Colors.white,
        child: Text(
          '$_remainingSeconds',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class PasswordResetLandingScreen extends StatefulWidget {
  const PasswordResetLandingScreen({super.key});

  @override
  State<PasswordResetLandingScreen> createState() =>
      _PasswordResetLandingScreenState();
}

class _PasswordResetLandingScreenState
    extends State<PasswordResetLandingScreen> {
  bool isButtonClickable = false;

  @override
  void initState() {
    super.initState();

    // Set a delay of 5 seconds before allowing the button to be clickable
    Timer(const Duration(seconds: 15), () {
      setState(() {
        isButtonClickable = true;
      });
    });
  }

  _handleButtonClick() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      await auth.sendPasswordResetEmail(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const CircleAvatar(
            radius: 30,
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            child: Icon(Icons.email_outlined, size: 30),
          ),
          const SizedBox(height: 15),
          const Text('Check your email',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          const Text(
            'You will receive a link to reset your password.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          TextButton(
            onPressed: isButtonClickable ? () => _handleButtonClick() : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Send link again in  ",
                    style: TextStyle(fontSize: 16),
                  ),
                  CountdownWidget(
                    seconds: 15,
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: const Center(
              child: Text(
                "Return to log in",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
