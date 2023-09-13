import 'package:flutter/material.dart';

class GeneratingMatchesScreen extends StatefulWidget {
  @override
  State<GeneratingMatchesScreen> createState() =>
      _GeneratingMatchesScreenState();
}

class _GeneratingMatchesScreenState extends State<GeneratingMatchesScreen> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 1),
        () => Navigator.pushNamed(context, '/hobbies'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Text(
            'Thanks, User!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28),
          ),
          const Text(
            'Generating hobbies...',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 25),
          const Icon(Icons.computer, size: 100)
        ],
      ),
    ));
  }
}
