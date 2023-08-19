import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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

Future<int?> writeSelectedInterest(userId, interestId) async {
  var response = await http.put(
      Uri.parse('http://127.0.0.1:8080/selected-interests'),
      body: {'user_id': userId, 'interest_id': interestId});

  return response.statusCode;
}

Future<int?> writeDeclinedInterest(userId, interestId) async {
  var response = await http.put(
      Uri.parse('http://127.0.0.1:8080/declined-interests'),
      body: {'user_id': userId, 'interest_id': interestId});

  return response.statusCode;
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
    for (int i = 0; i < hobbies.length; i++) {
      stack.add(
        Card(
          key: Key(i.toString()),
          elevation: 0, // Set elevation to 0 to remove the shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Set no border radius
          ),
          color: Colors.green,
          surfaceTintColor: Colors.white,
          child: Center(
            child: FadeInText(
              child: Text(hobbies[i],
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            ),
          ),
        ),
      );
    }

    bool devMode = (Platform.environment['DEV_MODE'] == null) ? false : true;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: devMode
            ? AppBar(
                elevation: 0,
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              )
            : null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: SwipableStack(
                  detectableSwipeDirections: const {
                    SwipeDirection.right,
                    SwipeDirection.left,
                  },
                  controller: _controller,
                  stackClipBehaviour: Clip.none,
                  onSwipeCompleted: (index, direction) {
                    // if direction == SwipeDirection.right, add to selected_interests table
                    // else, add to declined_interests
                    if (direction == SwipeDirection.right) {
                      writeSelectedInterest('1', '8');
                    } else {
                      writeDeclinedInterest('1', '1');
                    }
                  },
                  horizontalSwipeThreshold: 0.5,
                  verticalSwipeThreshold: 0.8,
                  builder: (context, properties) {
                    final itemIndex = properties.index % stack.length;

                    return stack[itemIndex];
                  },
                  overlayBuilder: (context, swipeProperty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Opacity(
                          opacity: swipeProperty.swipeProgress.clamp(0.1, 0.9),
                          child: Container(color: Colors.pink)),
                    );
                  },
                )),
          ],
        ));
  }
}

class Hobby {
  int id;
  String name;

  // Constructor
  Hobby({required this.id, required this.name});
}
