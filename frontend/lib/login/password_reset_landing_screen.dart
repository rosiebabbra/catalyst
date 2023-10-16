import 'dart:math' as math;
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
      backgroundColor: Colors.grey[800],
      radius: 13,
      child: CircleAvatar(
        radius: 11,
        backgroundColor: Colors.white,
        child: Text(
          '$_remainingSeconds',
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 35),
          Opacity(
            opacity: isButtonClickable ? 1.0 : 0.5,
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
                child: TextButton(
                  onPressed:
                      isButtonClickable ? () => _handleButtonClick() : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Resend link ",
                        style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                      ),
                      Visibility(
                        replacement: Container(),
                        visible: isButtonClickable ? false : true,
                        child: const CountdownWidget(
                          seconds: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Return to home page ",
                    style: TextStyle(fontSize: 15),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
