// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/chat/chat_list.dart';
import 'package:my_app/matches/match_screen.dart';
import 'package:my_app/my_profile/my_profile_screen.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/text_fade.dart';

class HobbyScreen extends StatefulWidget {
  String hobby;
  HobbyScreen({super.key, required this.hobby});

  @override
  HobbyScreenState createState() => HobbyScreenState();
}

Future<String> getInterests() async {
  var response = await http.get(Uri.parse('http://127.0.0.1:8080/interests'));

  return response.body;
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
  List<dynamic> hobbies = [];
  late final SwipableStackController _controller;
  void _listenController() => setState(() {});
  int currentNavbarIndex = 0;

  Future<List> serializeInterestsList() async {
    var result = await getInterests();
    var interests = jsonDecode(result);
    return interests;
  }

  void populateList() async {
    hobbies = await serializeInterestsList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
    populateList();
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
          elevation: 0,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInText(
                animationDuration: const Duration(milliseconds: 400),
                child: Text(hobbies[i]['interest'],
                    style: GoogleFonts.openSans(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center),
              ),
              FadeInText(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(hobbies[i]['interest_desc'],
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      );
    }

    bool devMode = (Platform.environment['DEV_MODE'] == null) ? false : true;

    void onTabTapped(int index) {
      setState(() {
        currentNavbarIndex = index;
      });
    }

    final List<Widget> pages = [
      interestSwipe(context, stack),
      const MatchScreen(userId: 1),
      const ChatList(),
      const MyProfileScreen()
    ];

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentNavbarIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Hatches'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), label: 'My Profile'),
          ],
        ),
        backgroundColor: Colors.white,
        appBar: devMode
            ? AppBar(
                elevation: 0,
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              )
            : null,
        body: pages[currentNavbarIndex]);
  }

  Column interestSwipe(BuildContext context, List<Card> stack) {
    return Column(
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
                if (direction == SwipeDirection.right) {
                  writeSelectedInterest(
                      '4', hobbies[index]['interest_id'].toString());
                } else if (direction == SwipeDirection.left) {
                  writeDeclinedInterest(
                      '1', hobbies[index]['interest_id'].toString());
                }
              },
              horizontalSwipeThreshold: 0.5,
              verticalSwipeThreshold: 0.8,
              builder: (context, properties) {
                if (stack.isEmpty) {
                  return const UnconstrainedBox(
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.pink),
                          strokeWidth: 8,
                        )),
                  );
                }
                final itemIndex = properties.index % stack.length;

                return stack[itemIndex];
              },
              overlayBuilder: (context, swipeProperty) {
                Color swipeColor =
                    swipeProperty.direction == SwipeDirection.right
                        ? Colors.green
                        : Colors.red;
                return Opacity(
                    opacity: swipeProperty.swipeProgress.clamp(0, 0.6),
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: swipeColor));
              },
            )),
      ],
    );
  }
}

class Hobby {
  int id;
  String name;

  // Constructor
  Hobby({required this.id, required this.name});
}
