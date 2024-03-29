import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_app/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;
import 'package:geocoding/geocoding.dart';

// Get all matches by:
// 1. Getting all user IDs in the current user's location
// 2. Loop through all user IDs and check if any match's
// interests overlap with current user's interests (list union or difference)
// 3. For the user IDs in which there is at least one common interest,
// generate a screen in the carousel with the user's information.
// Structure:
// Loop versus builder??????????
// - FutureBuilder to get the current user's location
// - StreamBuilder to get all users in the same area who also have at least
//   one common interest as current user
// - Generate each screen within the existing SingleChildScrollView

class Interests {
  final String interest;

  Interests(this.interest);
}

Future<List<DocumentSnapshot>> fetchDocumentsWithinRadius(
    GeoPoint currentUserLocation) async {
  double centerLatitude = currentUserLocation.latitude;
  double centerLongitude = currentUserLocation.longitude;
  GeoPoint centerGeoPoint = GeoPoint(centerLatitude, centerLongitude);

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  QuerySnapshot querySnapshot = await collectionRef
      .where('location',
          isGreaterThanOrEqualTo: centerGeoPoint,
          isLessThanOrEqualTo: centerGeoPoint)
      .get();

  List<DocumentSnapshot> eligibleMatches = querySnapshot.docs;
  print('****eligibleMatches***');
  print(eligibleMatches);
  return eligibleMatches;
}

Future<String> getCityFromCoordinates(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      String city = placemarks[0].locality ?? 'Unknown City';
      return city;
    }
  } catch (e) {
    print('Error fetching city name: $e');
  }

  return 'Unknown City';
}

Future<dynamic> getUserData(String userId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('user_id', isEqualTo: userId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      var recordData = document.data() as Map<String, dynamic>;
      return recordData;
    }
  } else {
    return {'first_name': 'Error rendering user name'};
  }
}

Future<List> getAllMatchedUserIds(String currentUserId) async {
  try {
    QuerySnapshot currentUserQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: currentUserId)
        .get();

    var document = currentUserQuerySnapshot.docs[0];
    var currentUserRecordData = document.data() as Map<String, dynamic>;
    var currentUserLatitude = currentUserRecordData['location'].latitude ?? 0;
    var currentUserLongitude = currentUserRecordData['location'].longitude ?? 0;
    var currentUserLocation =
        GeoPoint(currentUserLatitude, currentUserLongitude);

    var docs = fetchDocumentsWithinRadius(currentUserLocation);
    return docs;
  } catch (error) {
    print('Error in fetchData: $error');
    return [];
  }
}

Map<String, List<Interests>> interests = {
  '32bTzSuJfwUYwSbVBGdDGk5MM5g2': [
    Interests('Movies'),
    Interests('Music'),
    Interests('Reading'),
    Interests('Writing')
  ],
  'a3IXF0jBT0SkVW53hCIksmfsqAh2': [
    Interests('Movies'),
    Interests('Music'),
    Interests('Reading'),
    Interests('Writing')
  ]
};

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key, required this.userId});

  final int userId;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int currentNavbarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
        body: MatchProfile(
            index: currentNavbarIndex,
            controller: controller,
            interests:
                interests['32bTzSuJfwUYwSbVBGdDGk5MM5g2'] ?? [Interests('')]));
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
  int _currentPage = 0;
  final _pageWidth = 300.0;
  int matchCount = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<dynamic> fetchDataFuture;

  @override
  void initState() {
    String? currentUserId = auth.currentUser?.uid;
    super.initState();
    fetchDataFuture = getAllMatchedUserIds(currentUserId.toString());
    fetchDataFuture.then((result) {
      print('Fetch data completed'); // Handle the result here
      setState(() {
        matchCount = result;
      });
    });
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
    String? currentUserId = auth.currentUser?.uid;
    return Offstage(
      offstage: widget.index != 0,
      child: TickerMode(
        enabled: widget.index == 0,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                controller: widget.controller,
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                    future: getAllMatchedUserIds(currentUserId.toString()),
                    builder:
                        (BuildContext context, AsyncSnapshot matchSnapshot) {
                      if (matchSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (matchSnapshot.hasError) {
                        return Text('Error: ${matchSnapshot.error}');
                      } else if (!matchSnapshot.hasData ||
                          matchSnapshot.data.isEmpty) {
                        return const Text('No data available.');
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  controller: _controller,
                                  itemExtent: MediaQuery.of(context).size.width,
                                  physics: const PageScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: matchSnapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Reference ref = FirebaseStorage.instance
                                        .ref()
                                        .child('user_images')
                                        .child('${currentUserId}_1.jpg');

                                    return Column(
                                      children: [
                                        MatchName(
                                            name: matchSnapshot.data[index]
                                                    ['first_name']
                                                .toString()),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Opacity(
                                                opacity: index % 2 == 0
                                                    ? 1 - _visiblePercent
                                                    : _visiblePercent,
                                                child: FutureBuilder(
                                                    future:
                                                        ref.getDownloadURL(),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const SizedBox(
                                                          width: 100,
                                                          height: 100,
                                                          child: CircularProgressIndicator(
                                                              strokeWidth: 8,
                                                              color: Color(
                                                                  0xff33D15F)),
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else if (snapshot
                                                              .data ==
                                                          null) {
                                                        return const Text(
                                                            'Image not found'); // Handle null case
                                                      } else {
                                                        // Use the download URL to display the image
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius:
                                                                        15,
                                                                    spreadRadius:
                                                                        2,
                                                                    offset:
                                                                        const Offset(
                                                                            -5,
                                                                            10),
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3))
                                                              ]),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.75,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              child: Image.network(
                                                                  snapshot.data
                                                                      as String),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Stack(children: [
                              Opacity(
                                opacity: 0.7,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[600],
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for (int i = 0;
                                          i < matchSnapshot.data.length;
                                          i++)
                                        Icon(Icons.circle,
                                            color: _currentPage == i
                                                ? const Color(0xff09CBC8)
                                                : Colors.white,
                                            size: 8),
                                    ]),
                              )
                            ]),
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
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey[300]!),
                                ),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey[300]!))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(Icons.cake_outlined),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: (currentUserId != null)
                                                    ? FutureBuilder(
                                                        future: getUserData(
                                                            currentUserId),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator(
                                                                color: Color(
                                                                    0xff33D15F)); // Loading indicator
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          }
                                                          if (!snapshot
                                                              .hasData) {
                                                            return const Text(
                                                                'No sender IDs available.');
                                                          }

                                                          String calculateAge(
                                                              Timestamp
                                                                  timestamp) {
                                                            DateTime
                                                                currentDate =
                                                                DateTime.now();
                                                            DateTime birthDate =
                                                                DateTime.fromMillisecondsSinceEpoch(
                                                                    timestamp
                                                                        .millisecondsSinceEpoch);
                                                            int age =
                                                                currentDate
                                                                        .year -
                                                                    birthDate
                                                                        .year;

                                                            if (currentDate
                                                                        .month <
                                                                    birthDate
                                                                        .month ||
                                                                (currentDate.month ==
                                                                        birthDate
                                                                            .month &&
                                                                    currentDate
                                                                            .day <
                                                                        birthDate
                                                                            .day)) {
                                                              age--;
                                                            }

                                                            return age
                                                                .toString();
                                                          }

                                                          return Text('27',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                          .grey[
                                                                      900]));
                                                        },
                                                      )
                                                    : const Text(
                                                        'There was an error retrieving your data'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.grey[300]!))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.person_outline),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: (currentUserId != null)
                                                    ? FutureBuilder(
                                                        future: getUserData(
                                                            currentUserId),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator(
                                                                color: Color(
                                                                    0xff33D15F)); // Loading indicator
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          }
                                                          if (!snapshot
                                                              .hasData) {
                                                            return const Text(
                                                                'No sender IDs available.');
                                                          } else {
                                                            return Text(
                                                                'Female',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                            .grey[
                                                                        900]));
                                                          }
                                                        },
                                                      )
                                                    : const Text(
                                                        'There was an error retrieving this information.'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(Icons.location_pin,
                                                  size: 20),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: FutureBuilder(
                                                  future: getAllMatchedUserIds(
                                                      currentUserId.toString()),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot
                                                              matchSnapshot) {
                                                    if (matchSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const SizedBox
                                                          .shrink();
                                                    } else if (matchSnapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Error: ${matchSnapshot.error}');
                                                    } else if (!matchSnapshot
                                                            .hasData ||
                                                        matchSnapshot.data ==
                                                            null) {
                                                      return const Text(
                                                          'No data available');
                                                    } else {
                                                      return ListView.builder(
                                                          itemCount: matchCount,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            var city = getCityFromCoordinates(
                                                                matchSnapshot
                                                                    .data[index]
                                                                        [
                                                                        'location']
                                                                    .latitude,
                                                                matchSnapshot
                                                                    .data[index]
                                                                        [
                                                                        'location']
                                                                    .longitude);
                                                            return FutureBuilder(
                                                                future: city,
                                                                builder: (context,
                                                                    locationSnapshot) {
                                                                  if (locationSnapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return const CircularProgressIndicator();
                                                                  } else if (locationSnapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        'Error: ${locationSnapshot.error}');
                                                                  } else if (!locationSnapshot
                                                                          .hasData ||
                                                                      locationSnapshot
                                                                              .data ==
                                                                          null) {
                                                                    return const CircularProgressIndicator();
                                                                  } else {
                                                                    return Text(
                                                                        locationSnapshot
                                                                            .data
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.grey[900]));
                                                                  }
                                                                });
                                                          });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    //   child: Container(
                                    //     alignment: Alignment.center,
                                    //     child: Row(
                                    //       children: [
                                    //         const Icon(Icons.local_bar_outlined,
                                    //             size: 20),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8),
                                    //           child: Text(
                                    //             'Socially',
                                    //             style: TextStyle(
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Colors.grey[900]),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
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
                                border: Border.all(
                                    width: 0.5, color: Colors.grey[300]!),
                              ),
                              child: const Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 16, 0, 0),
                                          child: Icon(Icons.work_outline),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 16, 0, 0),
                                          child: Text(
                                            'Works at Google',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 16, 0, 0),
                                          child: Icon(Icons.school_outlined),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 16, 0, 0),
                                          child: Text(
                                            'University of California, Berkeley',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 16, 0, 0),
                                          child: Icon(Icons.home_outlined),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 16, 0, 0),
                                          child: Text(
                                            'Chicago, IL',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 16, 0, 0),
                                          child:
                                              Icon(Icons.auto_awesome_outlined),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 16, 0, 0),
                                          child: Text(
                                            'Agnostic',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(15.0, 0, 0, 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 16, 0, 0),
                                          child: Icon(Icons.ballot_outlined),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 16, 0, 0),
                                          child: Text(
                                            'Liberal',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: getUserData(currentUserId.toString()),
                              builder: (BuildContext context,
                                  AsyncSnapshot interestsSnapshot) {
                                if (interestsSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                } else if (interestsSnapshot.hasError) {
                                  return Text(
                                      'Error: ${interestsSnapshot.error}');
                                } else if (!interestsSnapshot.hasData ||
                                    interestsSnapshot.data == null) {
                                  return const Text('No data available');
                                } else {
                                  var firstName = interestsSnapshot
                                      .data['first_name']
                                      .toString();
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        35.0, 25, 0, 15),
                                    child: Row(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text("$firstName's interests",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            InterestsWidget(interests: widget.interests),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(5, 45, 5, 45),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ActionButton(
                                    passOrMatch: 'pass',
                                  ),
                                  SizedBox(width: 100),
                                  ActionButton(
                                    passOrMatch: 'match',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchName extends StatelessWidget {
  String name;

  MatchName({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35.0, 80, 0, 25),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            )
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

class ActionButton extends StatelessWidget {
  final String passOrMatch;
  const ActionButton({super.key, required this.passOrMatch});

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
                      const CircleBorder(
                          side: BorderSide(color: Colors.white))),
                ),
                child: (passOrMatch == 'pass')
                    ? const Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 40,
                      )
                    : const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 40,
                      ))),
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
