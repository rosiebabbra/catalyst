import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../utils/text_fade.dart';

Future<List<String>> readAndPopulateList() async {
  try {
    String fileContents =
        await rootBundle.loadString('assets/files/hobbies.txt');
    List<String> lines = fileContents.split('\n');
    return lines;
  } catch (e) {
    print('Error reading the file: $e');
    return [];
  }
}

class HobbyScreen extends StatefulWidget {
  String hobby;
  HobbyScreen({super.key, required this.hobby});

  @override
  HobbyScreenState createState() => HobbyScreenState();
}

class HobbyScreenState extends State<HobbyScreen> {
  List<String> hobbies = [];
  late final SwipableStackController _controller;
  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    populateList();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  void populateList() async {
    hobbies = await readAndPopulateList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Card> stack = [];
    int counter = 0;
    for (var item in hobbies) {
      stack.add(
        Card(
          elevation: 0, // Set elevation to 0 to remove the shadow
          shape: RoundedRectangleBorder(
            side: BorderSide.none, // Set no borders
            borderRadius: BorderRadius.circular(0), // Set no border radius
          ),
          borderOnForeground: false,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          child: Center(
            child: FadeInText(
              child: Text(item,
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: SizedBox(
            height: 500,
            width: 200,
            child: SwipableStack(
                detectableSwipeDirections: const {
                  SwipeDirection.right,
                  SwipeDirection.left,
                },
                controller: _controller,
                stackClipBehaviour: Clip.none,
                onSwipeCompleted: (index, direction) {
                  print('$index, $direction');
                  // if direction == SwipeDirection.right, add to selected_interests table
                  // else, add to declined_interests
                },
                horizontalSwipeThreshold: 0.8,
                verticalSwipeThreshold: 0.8,
                builder: (context, properties) {
                  final itemIndex = properties.index % stack.length;

                  return stack[itemIndex];
                })));
  }
}

class Hobby {
  int id;
  String name;

  // Constructor
  Hobby({required this.id, required this.name});
}
