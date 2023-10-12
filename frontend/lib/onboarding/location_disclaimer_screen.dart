import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/utils/text_fade.dart';

class LocationDisclaimerScreen extends StatefulWidget {
  final versionId;
  LocationDisclaimerScreen({super.key, required this.versionId});

  @override
  State<LocationDisclaimerScreen> createState() =>
      _LocationDisclaimerScreenState();
}

class _LocationDisclaimerScreenState extends State<LocationDisclaimerScreen> {
  var errorMsg = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double latitude = 0;
    double longitude = 0;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> getLocation() async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          latitude += position.latitude;
          longitude += position.longitude;
        });
      } catch (e) {
        print("Error getting location: $e");
      }
    }

    Future<void> writeData(
      String collection,
      String fieldToFilter,
      String valueToFilter,
      String columnToWrite,
      dynamic valueToWrite,
    ) async {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection(collection)
            .where(fieldToFilter, isEqualTo: valueToFilter)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If the document with the specified field and value exists, update the column
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          await documentSnapshot.reference
              .update({columnToWrite: valueToWrite});
          print('Column updated successfully!');
        }
      } catch (e) {
        print('Error writing to Firestore: $e');
      }
    }

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          errorMsg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
        const FadeInText(
            child: Icon(Icons.location_on, size: 50, color: Colors.black)),
        const SizedBox(height: 15),
        const FadeInText(
          delayStart: Duration(milliseconds: 500),
          animationDuration: Duration(seconds: 2),
          child: Text(
            'hatched needs location access to provide you the best experience.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        FadeInText(
            delayStart: const Duration(seconds: 3),
            child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Your precise location will ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'never ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'be shared with other users.'),
                  ],
                ))),
        const SizedBox(height: 30),
        FadeInText(
          delayStart: const Duration(seconds: 4),
          animationDuration: const Duration(milliseconds: 1200),
          child: Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                shape: BoxShape.rectangle,
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
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  shape: BoxShape.rectangle,
                  color: Colors.white),
              child: CupertinoButton(
                  onPressed: () async {
                    var status = await Geolocator.requestPermission();
                    if (status != LocationPermission.whileInUse) {
                      setState(() {
                        errorMsg = 'Please select "Allow While Using App"!';
                      });
                    } else {
                      await getLocation();

                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = auth.currentUser;
                      final currentUserId = user?.uid;

                      writeData('users', 'user_id', currentUserId.toString(),
                          'location', GeoPoint(latitude, longitude));

                      if (widget.versionId == 'beta') {
                        Navigator.pushNamed(context, '/coming-soon');
                      } else {
                        Navigator.pushNamed(context, '/generating-matches');
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 4),
                        child: Transform.rotate(
                            angle: 0.6,
                            child: Icon(Icons.navigation,
                                color: Colors.grey[700])),
                      ),
                      const Text(
                        'Enable location services',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
            ),
          ),
        )
      ]),
    ));
  }
}
