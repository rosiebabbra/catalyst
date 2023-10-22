// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/chat/chat_list.dart';
import 'package:my_app/matches/match_screen.dart';
import 'package:my_app/my_profile/my_profile_screen.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'dart:convert';

import '../utils/text_fade.dart';

class HobbyScreen extends StatefulWidget {
  const HobbyScreen({super.key});

  @override
  HobbyScreenState createState() => HobbyScreenState();
}

class InterestModel {
  final String interest;
  final String interestDesc;

  InterestModel({required this.interest, required this.interestDesc});

  factory InterestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return InterestModel(
      interest: snapshot.data()?['interest'] ?? '',
      interestDesc: snapshot.data()?['interest_desc'] ?? '',
    );
  }
}

Future<List<Map<String, dynamic>>> getInterests() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('your_collection').get();

  List<Map<String, dynamic>> dataList = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
    // Assuming 'column1' and 'column2' are the names of the two columns
    String interest = document.data()['interest'];
    String value2 = document.data()['interest_desc'];

    dataList.add({'interest': interest, 'column2': value2});
  }

  return dataList;
}

class HobbyScreenState extends State<HobbyScreen> {
  late final SwipableStackController _controller;
  void _listenController() => setState(() {});
  int currentNavbarIndex = 0;
  List<dynamic> hobbies = [];

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
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
    bool devMode = (Platform.environment['DEV_MODE'] == null) ? false : true;

    void onTabTapped(int index) {
      setState(() {
        currentNavbarIndex = index;
      });
    }

    final List<Widget> pages = [
      interestSwipe(context, []),
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
                icon: Icon(Icons.notifications), label: 'Matches'),
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

  interestSwipe(BuildContext context, List<Card> stack) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('interests').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<InterestModel> data = snapshot.data?.docs
                .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
                    InterestModel.fromSnapshot(doc))
                .toList() ??
            [];

        return SwipableStack(
          itemCount: data.length,
          builder: (context, properties) {
            final int index = properties.index;

            // try {
            //   index = properties.index % hobbies.length;
            // } catch (e) {
            //   index = 0;
            // }

            if (index >= data.length) {
              return Container();
            }

            return Card(
              child: ListTile(
                title: Text(data[index].interestDesc),
                subtitle: Text(data[index].interest),
              ),
            );
          },
          onSwipeCompleted: (index, direction) {
            // Handle swipe completion if needed
            print('Swiped $direction on item $index');
          },
        );
      },
    );
  }
}
