import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/chat/chat_list.dart';
import 'dart:math' as math;
import 'package:my_app/likes/like_screen.dart';
import 'package:my_app/my_profile/my_profile_screen.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/image_carousel.dart';

class Interests {
  final String interest;

  Interests(this.interest);
}

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key, required this.userId});

  final int userId;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int currentNavbarIndex = 0;

  List<Interests> interests = [
    Interests("Movies"),
    Interests("Music"),
    Interests("Reading"),
    Interests("Writing"),
  ];

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final List<Widget> pages = [
      MatchProfile(
          index: currentNavbarIndex,
          controller: controller,
          interests: interests),
      LikeScreen(
        userId: 1,
      ),
      ChatList(),
      MyProfileScreen()
    ];

    void onTabTapped(int index) {
      setState(() {
        currentNavbarIndex = index;
      });
    }

    return Scaffold(
        body: MatchProfile(
            index: currentNavbarIndex,
            controller: controller,
            interests: interests));
  }
}

class MatchProfile extends StatefulWidget {
  const MatchProfile({
    super.key,
    required this.index,
    required this.controller,
    required this.interests,
  });

  final int index;
  final PageController controller;
  final List<Interests> interests;

  @override
  State<MatchProfile> createState() => _MatchProfileState();
}

class _MatchProfileState extends State<MatchProfile> {
  final _controller = ScrollController();
  double _visiblePercent = 0.0;
  final _scrollSubject = BehaviorSubject<double>.seeded(0);
  int _currentPage = 0; // initialize to the first page
  final _pageWidth = 300.0; // replace with the width of your pages
  List<String> images = [
    'assets/images/profPic.jpg',
    'assets/images/profPic2.jpg',
    'assets/images/profPic3.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateVisiblePercent);
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final newPage = (_controller.offset / _pageWidth).floor();
    setState(() {
      _currentPage = newPage;
    });
  }

  void _updateVisiblePercent() {
    if (_controller.position.maxScrollExtent == 0 ||
        !_controller.position.hasContentDimensions) {
      setState(() {
        _visiblePercent = 1.0;
      });
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final double listViewWidth = renderBox?.size.width ?? 0.0;
    final double itemWidth = listViewWidth / 2;

    final double firstVisibleItemOffset =
        _controller.position.extentBefore / itemWidth;
    final double lastVisibleItemOffset =
        _controller.position.extentAfter / itemWidth;

    final double dominantItem = firstVisibleItemOffset > lastVisibleItemOffset
        ? firstVisibleItemOffset
        : lastVisibleItemOffset;

    final double nonDominantItem =
        firstVisibleItemOffset + lastVisibleItemOffset - dominantItem;

    final double percent = nonDominantItem / dominantItem;

    setState(() => _visiblePercent = percent);
  }

  @override
  void dispose() {
    _scrollSubject.close();
    _controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUserName(String senderId) async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .where('user_id', isEqualTo: senderId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the documents (there may be multiple matching records)
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          var recordData = document.data() as Map<String, dynamic>;
          return recordData['first_name'];
        }
      } else {
        return 'Error rendering user name';
      }
    }

    return Offstage(
      offstage: widget.index != 0,
      child: TickerMode(
        enabled: widget.index == 0,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: widget.controller,
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 70, 0, 0),
                    child: SizedBox(
                      width: 150,
                      height: 100,
                      child: Row(
                        children: [
                          FutureBuilder(
                            future: getUserName('a3IXF0jBT0SkVW53hCIksmfsqAh2'),
                            builder: (context, snapshot) {
                              var data = snapshot.data;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Loading indicator
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              if (!snapshot.hasData) {
                                return Text('No sender IDs available.');
                              }
                              return Text(
                                data,
                                style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            controller: _controller,
                            itemExtent: MediaQuery.of(context).size.width,
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Opacity(
                                          opacity: index % 2 == 0
                                              ? 1 - _visiblePercent
                                              : _visiblePercent,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                                key: ValueKey(index),
                                                images[index]),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width / 2 - 37.5,
                        bottom: 25,
                        child: Stack(children: [
                          Opacity(
                            opacity: 0.7,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(10)),
                                height: 20,
                                width: 75),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            height: 20,
                            width: 75,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (int i = 0; i < images.length; i++)
                                    Icon(Icons.circle,
                                        color: _currentPage == i
                                            ? Color(0xff7301E4)
                                            : Colors.white,
                                        size: 8),
                                ]),
                          )
                        ]),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        border:
                            Border.all(width: 0.5, color: Colors.grey[300]!),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300]!))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 5, 0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.cake_outlined),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('24',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[900])),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300]!))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person_outline),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Woman',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[900])),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300]!))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.favorite_outline),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Straight',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[900])),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300]!))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Row(
                                  children: [
                                    Transform.rotate(
                                      angle: 90 * math.pi / 180,
                                      child: const Icon(
                                        Icons.straighten,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "5'7",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[900]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300]!))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_pin, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'San Francisco Bay Area',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[900]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  const Icon(Icons.local_bar_outlined,
                                      size: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Socially',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      border: Border.all(width: 0.5, color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Icon(Icons.work_outline),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 16, 0, 0),
                                child: Text(
                                  'Works at Google',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Icon(Icons.school_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 16, 0, 0),
                                child: Text(
                                  'University of California, Berkeley',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Icon(Icons.home_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 16, 0, 0),
                                child: Text(
                                  'Chicago, IL',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Icon(Icons.auto_awesome_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 16, 0, 0),
                                child: Text(
                                  'Agnostic',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Icon(Icons.ballot_outlined),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 16, 0, 0),
                                child: Text(
                                  'Liberal',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 25, 0, 15),
                    child: Row(
                      children: const [
                        Text("Alice's interests",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                  InterestsWidget(interests: widget.interests),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: const [
                        PassButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DownArrow extends StatelessWidget {
  const DownArrow({
    super.key,
    required this.controller,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {
        controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        )
      },
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<CircleBorder>(
            const CircleBorder(side: BorderSide(color: Colors.white))),
      ),
      child: Icon(Icons.arrow_downward, color: Colors.grey[600], size: 35),
    );
  }
}

class PassButton extends StatelessWidget {
  const PassButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.grey[400]!,
                offset: const Offset(-5, 5),
                spreadRadius: 3)
          ],
        ),
        child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: TextButton(
              onPressed: () {
                // executeDate();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder(side: BorderSide(color: Colors.white))),
              ),
              child: const Icon(
                Icons.clear,
                color: Colors.red,
                size: 40,
              ),
            )),
      ),
    );
  }
}

class InterestsWidget extends StatelessWidget {
  const InterestsWidget({
    super.key,
    required this.interests,
  });

  final List<Interests> interests;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .85,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i in interests)
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextButton(
                style: ButtonStyle(
                    enableFeedback: false,
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff7301E4)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[100]!),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45),
                            side: BorderSide(color: Colors.grey[800]!)))),
                onPressed: () => {},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 3, 0),
                  child: Text(
                    i.interest,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
