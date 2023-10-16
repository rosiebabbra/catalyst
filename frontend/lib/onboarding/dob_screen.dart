import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DOBEntryScreen extends StatefulWidget {
  const DOBEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DOBEntryScreen> createState() => _DOBEntryScreenState();
}

class _DOBEntryScreenState extends State<DOBEntryScreen> {
  var errorMsg = '';
  DateTime selectedDate = DateTime.now();

  updateUserInfo(User? user, DateTime birthDate) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: user?.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assume there's only one matching document (you might need to adjust if multiple documents match)
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Get the document reference and update the fields
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.id);

      // Update the fields
      await documentReference.update({
        'birthdate': birthDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.cake_outlined, size: 30),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Your birthday?",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text('Your profile shows your age, not your date of birth.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              const SizedBox(height: 15),
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  key: const Key('dobPicker'),
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      DateTime.now().subtract(const Duration(days: 18 * 365)),
                  minimumDate:
                      DateTime.now().subtract(const Duration(days: 100 * 365)),
                  maximumDate:
                      DateTime.now().subtract(const Duration(days: 18 * 365)),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Row(children: [
                if (errorMsg.isNotEmpty)
                  const Icon(Icons.info_outline, size: 20, color: Colors.red),
                if (errorMsg.isNotEmpty) const Text(' '),
                if (errorMsg.isNotEmpty)
                  Expanded(
                      child: Text(errorMsg,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold))),
              ]),
              if (errorMsg.isNotEmpty)
                const SizedBox(
                  height: 25,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 32.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: 75,
                        width: 75,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3.5, color: Colors.transparent),
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
                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? currentUser = auth.currentUser;
                                updateUserInfo(currentUser, selectedDate);
                                Navigator.pushNamed(
                                    context, '/onboarding-gender');
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
