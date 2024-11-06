import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/utils/utils.dart';

class MatchScreen extends StatefulWidget {
  final String matchId;
  MatchScreen({super.key, required this.matchId});

  @override
  State<MatchScreen> createState() => MatchScreenState();
}

class MatchScreenState extends State<MatchScreen> {
  int currentNavbarIndex = 0;
  List<String> interestNames = [];
  final Set<String> interestIds = Set();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
        body: MatchProfile(
            index: currentNavbarIndex,
            controller: controller,
            matchId: widget.matchId.toString(),
            interests: interestNames));
  }
}

class MatchProfile extends StatefulWidget {
  const MatchProfile(
      {super.key,
      required this.index,
      required this.controller,
      required this.interests,
      required this.matchId});

  final int index;
  final PageController controller;
  final List<String> interests;
  final String matchId;

  @override
  State<MatchProfile> createState() => MatchProfileState();
}

class MatchProfileState extends State<MatchProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int numImages = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Offstage(
        offstage: widget.index != 0,
        child: FutureBuilder(
            future: getUserData(widget.matchId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return TickerMode(
                enabled: widget.index == 0,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                MatchName(name: snapshot.data['first_name']),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .ref()
                                              .child('user_images')
                                              .child('${widget.matchId}.jpg')
                                              .getDownloadURL(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox(
                                                width: 100,
                                                height: 100,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 8,
                                                        color:
                                                            Color(0xff33D15F)),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if (snapshot.data == null) {
                                              return const Text(
                                                  'Image not found'); // Handle null case
                                            } else {
                                              // Get number of user images for indicator
                                              // We are hard coding it as 1 right now.
                                              // Currently, the future value of ref.getDownloadURL()
                                              // is simply a string link of ONE image.
                                              // Eventually, when we allow for multiple image upload,
                                              // we will need to use something like snapshot.data.length
                                              // which will ideally be a list/array of image links.
                                              numImages = 1;
                                              // Use the download URL to display the image
                                              return Container(
                                                decoration:
                                                    BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 15,
                                                      spreadRadius: 2,
                                                      offset:
                                                          const Offset(-5, 10),
                                                      color: Colors.grey
                                                          .withOpacity(0.3))
                                                ]),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: Image.network(
                                                      snapshot.data.toString(),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.85,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                      fit: BoxFit.cover),
                                                ),
                                              );
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Positioned(
                            //   bottom: MediaQuery.of(context).size.height * 0.05,
                            //   left: MediaQuery.of(context).size.width * 0.375,
                            //   child: Stack(children: [
                            //     Opacity(
                            //       opacity: 0.7,
                            //       child: Container(
                            //           decoration: BoxDecoration(
                            //               color: Colors.grey[600],
                            //               borderRadius:
                            //                   BorderRadius.circular(10)),
                            //           height: 20,
                            //           width: 75),
                            //     ),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //           color: Colors.transparent,
                            //           borderRadius: BorderRadius.circular(10)),
                            //       height: 20,
                            //       width: 75,
                            //       child: Row(
                            //           // crossAxisAlignment:
                            //           //     CrossAxisAlignment.center,
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceEvenly,
                            //           children: [
                            //             for (int i = 0; i < numImages; i++)
                            //               Icon(Icons.circle,
                            //                   color: _currentPage == i
                            //                       ? const Color(0xff09CBC8)
                            //                       : Colors.white,
                            //                   size: 8),
                            //           ]),
                            //     )
                            //   ]),
                            // )
                          ],
                        )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              child: Text(
                                                  calculateAge(snapshot
                                                          .data['birthdate'])
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey[900]))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              child: Text(
                                                  snapshot.data['gender'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey[900]))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                              padding: const EdgeInsets.all(8),
                                              child: FutureBuilder(
                                                  future:
                                                      getCityFromCoordinates(
                                                          snapshot
                                                              .data['location']
                                                              .latitude,
                                                          snapshot
                                                              .data['location']
                                                              .longitude),
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
                                                        locationSnapshot.data ==
                                                            null) {
                                                      return const CircularProgressIndicator();
                                                    } else {
                                                      return Text(
                                                          locationSnapshot.data
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[900]));
                                                    }
                                                  })),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.local_bar_outlined,
                                            size: 20),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            snapshot.data['drinking'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.smoking_rooms,
                                            size: 25),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            snapshot.data['marijuana'],
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
                            border: Border.all(
                                width: 0.5, color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              (snapshot.data['occupation'] != null)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Icon(Icons.work_outline),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 16, 0, 0),
                                            child: Text(
                                              snapshot.data['occupation'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              (snapshot.data['college'] != null)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Icon(Icons.school_outlined),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 16, 0, 0),
                                            child: Text(
                                              snapshot.data['college']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              (snapshot.data['hometown'] != null)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Icon(Icons.home_outlined),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 16, 0, 0),
                                            child: Text(
                                              snapshot.data['hometown'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              (snapshot.data['religious_pref'] != null)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Icon(
                                                Icons.auto_awesome_outlined),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 16, 0, 0),
                                            child: Text(
                                              snapshot.data['religious_pref'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              (snapshot.data['political_affiliation'] != null)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0, 0, 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 16, 0, 0),
                                            child: Icon(Icons.ballot_outlined),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 16, 0, 0),
                                            child: Text(
                                              snapshot.data[
                                                  'political_affiliation'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 16)
                            ],
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(35.0, 25, 0, 15),
                        //   child: Row(
                        //     children: [
                        //       FittedBox(
                        //         fit: BoxFit.scaleDown,
                        //         child: Text("Caroline's interests",
                        //             style: TextStyle(
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.black)),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // InterestsWidget(uid: auth.currentUser?.uid),
                        // const SizedBox(height: 100)
                      ],
                    ),
                  ],
                ),
              );
            }),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 100)
      ],
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
