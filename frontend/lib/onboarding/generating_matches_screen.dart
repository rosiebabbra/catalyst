import 'package:flutter/material.dart';

class GeneratingMatchesScreen extends StatefulWidget {
  const GeneratingMatchesScreen({super.key});

  @override
  State<GeneratingMatchesScreen> createState() =>
      _GeneratingMatchesScreenState();
}

class _GeneratingMatchesScreenState extends State<GeneratingMatchesScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1),
        () => Navigator.pushNamed(context, '/hobbies'));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            'Thanks, User!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28),
          ),
          Text(
            'Generating hobbies...',
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(height: 25),
          Icon(Icons.computer, size: 100)
        ],
      ),
    ));
  }
}
