import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/chat/chat_list.dart';
import 'package:my_app/matches/match_screen.dart';
import 'package:my_app/my_profile/my_profile_screen.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../utils/text_fade.dart';

class HobbyScreen extends StatefulWidget {
  const HobbyScreen({super.key});

  @override
  HobbyScreenState createState() => HobbyScreenState();
}

class InterestModel {
  final String interest;
  final String interestDesc;
  final int interestId;

  InterestModel(
      {required this.interest,
      required this.interestDesc,
      required this.interestId});

  factory InterestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return InterestModel(
      interest: snapshot.data()?['interest'] ?? '',
      interestDesc: snapshot.data()?['interest_desc'] ?? '',
      interestId: snapshot.data()?['interest_id'] ?? '',
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
    void onTabTapped(int index) {
      setState(() {
        currentNavbarIndex = index;
      });
    }

    final List<Widget> pages = [
      interestSwipe(context),
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
        body: pages[currentNavbarIndex]);
  }

  interestSwipe(BuildContext context) {
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

        writeInterest(User? user, String table, int interestId) async {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection(table)
              .where('user_id', isEqualTo: user?.uid)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

            DocumentReference documentReference = FirebaseFirestore.instance
                .collection(table)
                .doc(documentSnapshot.id);

            await documentReference.update({
              'interest_id': FieldValue.arrayUnion([interestId]),
              'user_id': user?.uid
            });
          } else {
            FirebaseFirestore.instance.collection(table).add({
              'user_id': user?.uid,
              'interest_id': [interestId]
            });
          }
        }

        if (data.isEmpty) {
          return const UnconstrainedBox(
            child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  strokeWidth: 8,
                )),
          );
        }

        return SwipableStack(
          horizontalSwipeThreshold: 0.5,
          verticalSwipeThreshold: 0.8,
          itemCount: data.length,
          stackClipBehaviour: Clip.none,
          overlayBuilder: (context, swipeProperty) {
            Color swipeColor = swipeProperty.direction == SwipeDirection.right
                ? const Color(0xff33D15F)
                : const Color(0xff7301E4);
            return Opacity(
                opacity: swipeProperty.swipeProgress.clamp(0, 0.6),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: swipeColor));
          },
          builder: (context, properties) {
            final int index = properties.index;

            if (index >= data.length) {
              return Container();
            }

            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [
                            Color(0xff7301E4),
                            Color(0xff0E8BFF),
                            Color(0xff09CBC8),
                            Color(0xff33D15F),
                          ],
                          stops: [0.0, 0.25, 0.5, 0.75],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds);
                      },
                      child: FittedBox(
                        child: Text(data[index].interest,
                            style: const TextStyle(
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      )),
                  FadeInText(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(data[index].interestDesc,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                          )),
                    ),
                  )
                ],
              ),
            );
          },
          onSwipeCompleted: (index, direction) {
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            if (direction == SwipeDirection.right) {
              writeInterest(user, 'selected_interests', data[index].interestId);
            } else if (direction == SwipeDirection.left) {
              writeInterest(user, 'declined_interests', data[index].interestId);
            }
          },
        );
      },
    );
  }
}
