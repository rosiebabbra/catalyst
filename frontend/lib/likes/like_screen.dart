import 'package:flutter/material.dart';
import 'dart:math' as math;

class Interests {
  final String interest;

  Interests(this.interest);
}

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key, required this.userId});

  final int userId;

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  int currentIndex = 0;

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
          index: currentIndex, controller: controller, interests: interests),
      Scaffold(body: Container(height: 500, width: 200, color: Colors.red)),
      Scaffold(body: Container(height: 500, width: 200, color: Colors.blue)),
      Scaffold(body: Container(height: 500, width: 200, color: Colors.green))
    ];

    void onTabTapped(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return Scaffold(
      body: pages[currentIndex],
    );
  }
}

class MatchProfile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Offstage(
      offstage: index != 0,
      child: TickerMode(
        enabled: index == 0,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 70, 0, 0),
                    child: Row(
                      children: const [
                        Text(
                          'Lauren',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.asset(
                          'assets/images/profPic2.jpg',
                          width: MediaQuery.of(context).size.width * 0.85,
                        ),
                      )
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
                                      child: Text('28',
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
                                      child: Text('Prefer not to say',
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
                                        "5'4",
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
                                  'Works at Pinterest',
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
                                  'California Institute of Technology',
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
                                  'San Diego, CA',
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
                                  'Atheist',
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
                                  'Moderate',
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
                  InterestsWidget(interests: interests),
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
