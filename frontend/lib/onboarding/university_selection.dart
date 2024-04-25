import 'dart:convert';
import 'dart:math' as math;
import 'package:catalyst/onboarding/vice_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

updateUserCollege(User? user, String university) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('user_id', isEqualTo: user?.uid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Assume there's only one matching document (you might need to adjust if multiple documents match)
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    // Get the document reference and update the fields
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(documentSnapshot.id);

    // Update the fields
    await documentReference.update({
      'university': university,
    });
  } else {}
}

class UniversitySelectionScreen extends StatefulWidget {
  const UniversitySelectionScreen({super.key});

  @override
  UniversitySelectionScreenState createState() =>
      UniversitySelectionScreenState();
}

class UniversitySelectionScreenState extends State<UniversitySelectionScreen> {
  List<dynamic> universities = [];
  List<dynamic> fetchedUniversities = [];

  @override
  void initState() {
    super.initState();
    getUniversityList();
  }

  void getUniversityList() async {
    try {
      fetchedUniversities = await getUniversities();
      if (mounted) {
        setState(() {
          universities = fetchedUniversities;
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching universities: $e');
      }
    }
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

    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.325),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: Icon(Icons.school, size: 50),
        ),
        const SizedBox(height: 20),
        const Text('College',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Text(
          'Please select where you went to school.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '(Optional)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: DropdownSearch(
              clearButtonProps: const ClearButtonProps(isVisible: true),
              popupProps: const PopupProps.bottomSheet(showSearchBox: true),
              items: universities,
              onChanged: (value) {
                // Write to db
                updateUserCollege(user, value ?? ''); // TEST!
              },
            ),
          ),
        ),
        const SizedBox(height: 150),
        Padding(
          padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
          child: SizedBox(
              height: 75,
              width: 75,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3.5, color: Colors.transparent),
                    gradient: const LinearGradient(
                      transform: GradientRotation(math.pi / 4),
                      colors: [
                        Color(0xff7301E4),
                        Color(0xff0E8BFF),
                        Color(0xff09CBC8),
                        Color(0xff33D15F),
                      ],
                    )),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: TextButton(
                      child: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViceScreen()),
                        );
                      }
                      // },
                      ),
                ),
              )),
        )
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
