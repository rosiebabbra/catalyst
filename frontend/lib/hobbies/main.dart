import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/chat/chat_list.dart';
import 'package:catalyst/my_profile/my_profile_screen.dart';
import 'package:swipable_stack/swipable_stack.dart';
import '../utils/text_fade.dart';

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

writeInterest(User? user, String table, int interestId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(table)
      .where('user_id', isEqualTo: user?.uid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(table).doc(documentSnapshot.id);

    await documentReference.update({
      'interest_ids': FieldValue.arrayUnion([interestId]),
      'user_id': user?.uid
    });
  } else {
    FirebaseFirestore.instance.collection(table).add({
      'user_id': user?.uid,
      'interest_ids': [interestId]
    });
  }
}

class HobbyScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double radiusInMiles;
  // const LoginScreen({super.key, required this.versionId});
  const HobbyScreen(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.radiusInMiles});

  @override
  HobbyScreenState createState() => HobbyScreenState();
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

  void onTabTapped(int index) {
    setState(() {
      currentNavbarIndex = index;
    });
  }

  Future<Set> fetchExclusionList() async {
    final selectedInterests =
        await FirebaseFirestore.instance.collection('selected_interests').get();
    final declinedInterests =
        await FirebaseFirestore.instance.collection('declined_interests').get();

    Set<dynamic> exclusions = {
      ...selectedInterests.docs.expand((doc) => doc['interest_ids']).toSet(),
      ...declinedInterests.docs.expand((doc) => doc['interest_ids']).toSet(),
    };

    return exclusions;
  }

  interestSwipe(BuildContext context) {
    return FutureBuilder(
        future: fetchExclusionList(),
        builder: (context, snapshot) {
          final exclusionList = snapshot.data;

          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('interests').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xff7301E4)),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xff7301E4)),
                );
              }

              final docs = snapshot.data?.docs
                  .where((doc) =>
                      exclusionList != null &&
                      !exclusionList.contains(doc['interest_id']))
                  .toList();

              if (docs!.isEmpty) {
                return const UnconstrainedBox(
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff33D15F)),
                          strokeWidth: 8,
                        ),
                      )),
                );
              }

              return SwipableStack(
                horizontalSwipeThreshold: 0.5,
                verticalSwipeThreshold: 0.8,
                itemCount: docs.isNotEmpty ? docs.length : 0,
                stackClipBehaviour: Clip.none,
                overlayBuilder: (context, swipeProperty) {
                  Color swipeColor =
                      swipeProperty.direction == SwipeDirection.right
                          ? const Color(0xff33D15F)
                          : const Color(0xff7301E4);
                  return Opacity(
                      opacity: swipeProperty.swipeProgress.clamp(0, 0.6),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: swipeColor),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ));
                },
                builder: (context, properties) {
                  final int index = properties.index;

                  if (index >= docs.length) {
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
                              child: Text(docs[index]['interest'],
                                  style: const TextStyle(
                                    fontSize: 36.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                            )),
                        FadeInText(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(docs[index]['interest_desc'],
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
                    writeInterest(
                        user, 'selected_interests', docs[index]['interest_id']);
                  } else if (direction == SwipeDirection.left) {
                    writeInterest(
                        user, 'declined_interests', docs[index]['interest_id']);
                  }
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      interestSwipe(context),
      const ChatList(userIds: ['abc']),
      const MyProfileScreen()
    ];
    // Load all users on start so that we have access to them all
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentNavbarIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake_outlined), label: 'Matches'),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border), label: 'My Profile'),
          ],
        ),
        backgroundColor: Colors.white,
        body: pages[currentNavbarIndex]);
  }
}
