import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/utils/utils.dart';
import 'package:catalyst/onboarding/dob_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/single_child_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  get selectedDate => DateTime.now().subtract(const Duration(days: 18 * 365));

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  DateTime selectedDate =
      DateTime.now().subtract(const Duration(days: 18 * 365));
  double latitude = 0;
  double longitude = 0;
  var errorMsg = '';
  var permission = LocationPermission.always;
  List<dynamic> universities = []; // Display list
  List<dynamic> originalUniversities = []; // Keep original data
  List<dynamic> fetchedUniversities = [];
  TextEditingController uniNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUniversityList();
    uniNameController.addListener(filterUniversities);
  }

  @override
  void dispose() {
    uniNameController
        .dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  void getUniversityList() async {
    try {
      fetchedUniversities = await getUniversities();
      if (mounted) {
        setState(() {
          universities = fetchedUniversities;
          originalUniversities = [...fetchedUniversities]; // Create a copy
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching universities: $e');
      }
    }
  }

  void filterUniversities() {
    setState(() {
      universities = originalUniversities
          .where((element) => element.toLowerCase().contains(
                uniNameController.text.toLowerCase(),
              ))
          .toList();
    });
  }

  Future<List<dynamic>> getUniversities() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://universities.hipolabs.com/search?country=united+states'));
    request.body = '''''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String apiResponse = await response.stream.bytesToString();
      var universityData = jsonDecode(apiResponse);
      universityData.sort((a, b) {
        String nameA = a['name'] ?? '';
        String nameB = b['name'] ?? '';
        return nameA.compareTo(nameB);
      });
      print(universityData[0]);
      List<dynamic> universityNames = universityData.map((uni) {
        return uni['name'] ?? 'Unknown';
      }).toList();
      return universityNames;
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final currentUserId = user?.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<String>(
              color: Colors.white,
              onSelected: (String value) {
                // Handle menu item selection here
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
              surfaceTintColor: Colors.white,
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'Logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Builder(builder: (builderContext) {
            return FutureBuilder(
                future: getUserData(currentUserId.toString()),
                builder:
                    (BuildContext context, AsyncSnapshot userDataSnapshot) {
                  if (userDataSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Stack(children: [
                            FutureBuilder(
                              future: findValidFirebaseUrl(
                                  currentUserId.toString()),
                              builder: (BuildContext context,
                                  AsyncSnapshot imageSnapshot) {
                                var imageFile =
                                    NetworkImage(imageSnapshot.data.toString());
                                if (imageSnapshot.data == null) {
                                  return CircularProgressIndicator();
                                }
                                return Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                      image: imageFile,
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                        color: Colors.grey, width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0)),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 14.5,
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 12.5,
                                      child: Icon(Icons.edit_outlined,
                                          color: Colors.black, size: 20)),
                                ),
                                top: 0,
                                right: 0)
                          ]),
                        ),
                      ),
                      (userDataSnapshot.data['first_name'] != null)
                          ? Text(userDataSnapshot.data['first_name'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700))
                          : const CircularProgressIndicator(),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            'About me',
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 20, 15, 20),
                                child: Text(
                                  'Age',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: Column(
                                                    children: [
                                                      Text(
                                                          'Select date of birth'),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Close'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Update'),
                                                      onPressed: () {
                                                        FirebaseAuth auth =
                                                            FirebaseAuth
                                                                .instance;
                                                        User? currentUser =
                                                            auth.currentUser;
                                                        var intBirthDate =
                                                            selectedDate.year *
                                                                    10000 +
                                                                selectedDate
                                                                        .month *
                                                                    100 +
                                                                selectedDate
                                                                    .day;
                                                        updateUserBirthdate(
                                                            currentUser,
                                                            intBirthDate);
                                                      },
                                                    )
                                                  ],
                                                  content: SizedBox(
                                                    height: 250,
                                                    child: CupertinoDatePicker(
                                                      key: const Key(
                                                          'dobPicker'),
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .date,
                                                      initialDateTime:
                                                          parseDateFromInt(
                                                              userDataSnapshot
                                                                      .data[
                                                                  'birthdate']),
                                                      minimumDate: DateTime
                                                              .now()
                                                          .subtract(
                                                              const Duration(
                                                                  days: 100 *
                                                                      365)),
                                                      maximumDate: DateTime
                                                              .now()
                                                          .subtract(
                                                              const Duration(
                                                                  days: 18 *
                                                                      365)),
                                                      onDateTimeChanged:
                                                          (DateTime newDate) {
                                                        setState(() {
                                                          selectedDate =
                                                              newDate;
                                                        });
                                                      },
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Text(
                                                calculateAge(userDataSnapshot
                                                        .data['birthdate'])
                                                    .toString(),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, right: 15),
                                      child: Icon(Icons.arrow_forward_ios,
                                          size: 15),
                                    ),
                                  ]),
                            ],
                          ),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 20, 15, 20),
                              child: Text(
                                'Location',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  onPressed: () async {
                                    {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return DraggableScrollableSheet(
                                            expand: false,
                                            builder:
                                                (context, scrollController) {
                                              return ListView.builder(
                                                controller: scrollController,
                                                itemCount: cities.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: TextButton(
                                                      child:
                                                          Text(cities[index]),
                                                      onPressed: () async {
                                                        await writeData(
                                                            'users',
                                                            'user_id',
                                                            currentUserId
                                                                .toString(),
                                                            'location',
                                                            cities[index]);
                                                        setState(
                                                          () {},
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                            userDataSnapshot.data['location'],
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios, size: 15),
                                ),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 20, 15, 20),
                              child: Text(
                                'Gender',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  onPressed: () async {
                                    {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return DraggableScrollableSheet(
                                            expand: false,
                                            builder:
                                                (context, scrollController) {
                                              return ListView.builder(
                                                controller: scrollController,
                                                itemCount:
                                                    genderIdentities.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: TextButton(
                                                      child: Text(
                                                          genderIdentities[
                                                              index]),
                                                      onPressed: () async {
                                                        await writeData(
                                                            'users',
                                                            'user_id',
                                                            currentUserId
                                                                .toString(),
                                                            'gender',
                                                            genderIdentities[
                                                                index]);
                                                        setState(
                                                          () {},
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                            userDataSnapshot.data['gender'],
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios, size: 15),
                                ),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 20, 15, 20),
                              child: Text(
                                'Drinking',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black)),
                                    onPressed: () async {
                                      {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return DraggableScrollableSheet(
                                              expand: false,
                                              builder:
                                                  (context, scrollController) {
                                                return ListView.builder(
                                                  controller: scrollController,
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var choices = [
                                                      'Socially',
                                                      'Rarely',
                                                      'Never'
                                                    ];
                                                    return ListTile(
                                                      title: TextButton(
                                                        child: Text(
                                                            choices[index]),
                                                        onPressed: () async {
                                                          await writeData(
                                                              'users',
                                                              'user_id',
                                                              currentUserId
                                                                  .toString(),
                                                              'drinking',
                                                              choices[index]);
                                                          setState(
                                                            () {},
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                              userDataSnapshot.data['drinking'],
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios, size: 15),
                                ),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 20, 15, 20),
                              child: Text(
                                'Occupation',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black)),
                                    onPressed: () async {
                                      {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return DraggableScrollableSheet(
                                              expand: false,
                                              builder:
                                                  (context, scrollController) {
                                                return ListView.builder(
                                                  controller: scrollController,
                                                  itemCount: occupations.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: TextButton(
                                                        child: Text(
                                                            occupations[index]),
                                                        onPressed: () async {
                                                          await writeData(
                                                              'users',
                                                              'user_id',
                                                              currentUserId
                                                                  .toString(),
                                                              'occupation',
                                                              occupations[
                                                                  index]);
                                                          setState(
                                                            () {},
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: [
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 125),
                                            child: Text(
                                                userDataSnapshot
                                                    .data['occupation'],
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios, size: 15),
                                ),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 20, 15, 20),
                              child: Text(
                                'University',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black)),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (uniContext, setModalState) {
                                            return SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          uniNameController,
                                                      onChanged: (value) {
                                                        // Filter universities and update the modal state
                                                        setModalState(() {
                                                          universities = originalUniversities
                                                              .where((element) => element
                                                                  .toLowerCase()
                                                                  .contains(value
                                                                      .toLowerCase()))
                                                              .toList();
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.3,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            universities.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                              title:
                                                                  GestureDetector(
                                                            onTap: () async {
                                                              await writeData(
                                                                  'users',
                                                                  'user_id',
                                                                  currentUserId
                                                                      .toString(),
                                                                  'university',
                                                                  universities[
                                                                      index]);
                                                              setState(
                                                                () {},
                                                              );
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                universities[
                                                                    index]),
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                          });
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        children: [
                                          ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 125),
                                            child: Text(
                                                userDataSnapshot
                                                    .data['university']
                                                    .toString(),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, right: 15),
                                  child:
                                      Icon(Icons.arrow_forward_ios, size: 15),
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                            child: Text(
                              'Interests',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text('Tap a category to remove',
                              softWrap: true,
                              style: TextStyle(color: Colors.grey[700])),
                        )
                      ]),
                      InterestsWidget(uid: currentUserId.toString()),
                    ],
                  );
                });
          }),
        ));
  }
}

class InterestsWidget extends StatefulWidget {
  final String uid;

  InterestsWidget({super.key, required this.uid});

  @override
  State<InterestsWidget> createState() => _InterestsWidgetState();
}

class _InterestsWidgetState extends State<InterestsWidget> {
  final colors = [
    Colors.pink,
    const Color.fromARGB(255, 207, 117, 223),
    const Color.fromARGB(255, 90, 166, 228),
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.cyan
  ];
  List interestIds = [];
  List interests = [];
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getInterests();
  }

  getInterests() async {
    var retrievedInterestSnapshot = await getSelectedInterests(widget.uid);
    for (var doc in retrievedInterestSnapshot.docs) {
      interestIds.addAll(doc['interest_ids']);
    }
    for (int interestId in interestIds) {
      var interestName = await getInterestNameFromId(interestId);
      interests.add(interestName.docs[0]['interest']);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        width: MediaQuery.sizeOf(context).width * 0.75,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemCount: interests.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              Container(child: Text('Remove this interest?')),
                          actions: [
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                CollectionReference selectedInterests =
                                    FirebaseFirestore.instance
                                        .collection('selected_interests');
                                QuerySnapshot querySnapshot =
                                    await selectedInterests
                                        .where('user_id',
                                            isEqualTo: currentUserId)
                                        .get();

                                // Loop through all documents that match the query and update them
                                for (var doc in querySnapshot.docs) {
                                  await doc.reference.update({
                                    'interest_ids': FieldValue.arrayRemove(
                                        [interestIds[index]])
                                  });
                                }
                                interestIds = [];
                                interests = [];
                                getInterests();
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Center(
                      child: Text(
                        interests[index],
                        maxLines: 1,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
