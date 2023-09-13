import 'package:flutter/material.dart';

class PasswordResetLandingScreen extends StatelessWidget {
  const PasswordResetLandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('Please check your email to reset your password.',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ),
          TextButton(
            onPressed: () {
              // TODO: Add logic to wait x number of seconds before being able to request
              // another reset link
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: const Text(
              "Send link again",
              style: TextStyle(fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: const Text(
              "Return to log in",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    ));
  }
}
