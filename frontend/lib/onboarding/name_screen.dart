import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NameEntryScreen extends StatefulWidget {
  const NameEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends State<NameEntryScreen> {
  var emptyNameErrorMsg = '';
  var incorrectlyFormattedErrorMsg = '';
  TextEditingController controller = TextEditingController();

  updateUserInfo(User? currentUser, String firstName) {
    FirebaseFirestore.instance.collection('users').add({
      'first_name': firstName,
      'timestamp': Timestamp.now(),
      'user_id': currentUser?.uid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.question_answer, size: 50),
              const SizedBox(
                height: 15,
              ),
              const Text("What's your first name?",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Text('This is how your name will appear on your profile.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])),
              Text(
                "You can't change it later.",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                autofocus: true,
                maxLength: 35,
                controller: controller,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Enter your first name',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              Column(
                children: [
                  Padding(
                    padding: emptyNameErrorMsg.isNotEmpty
                        ? const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0)
                        : const EdgeInsets.all(0),
                    child: Row(children: [
                      if (emptyNameErrorMsg.isNotEmpty)
                        const Icon(Icons.info_outline,
                            size: 20, color: Colors.red),
                      if (emptyNameErrorMsg.isNotEmpty) const Text(' '),
                      Text(emptyNameErrorMsg,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: incorrectlyFormattedErrorMsg.isNotEmpty
                        ? const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0)
                        : const EdgeInsets.all(0),
                    child: Row(children: [
                      if (incorrectlyFormattedErrorMsg.isNotEmpty)
                        const Icon(Icons.info_outline,
                            size: 20, color: Colors.red),
                      if (incorrectlyFormattedErrorMsg.isNotEmpty)
                        const Text(' '),
                      Expanded(
                        child: Text(incorrectlyFormattedErrorMsg,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ),
                    ]),
                  ),
                ],
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
                                /// Applies formatting to the user inputted string by trimming
                                /// leading and trailing whitespace, formatting to titlecase
                                /// capitalization, and ensures that only alphabetic characters
                                /// are submitted.
                                formatName(String inputName) {
                                  try {
                                    var initiallyFormattedName =
                                        "${inputName[0].toUpperCase()}${inputName.substring(1).toLowerCase()}"
                                            .trim();

                                    // Commenting out input regex restriction to avoid it being
                                    // a hindrance to people registering
                                    // RegExp regExp = RegExp(r"^[A-Z][a-z'-]*$");
                                    // if (regExp
                                    //     .hasMatch(initiallyFormattedName)) {
                                    //   setState(() {
                                    //     incorrectlyFormattedErrorMsg = '';
                                    //   });
                                    return initiallyFormattedName;
                                    // } else {
                                    //   setState(() {
                                    //     incorrectlyFormattedErrorMsg =
                                    //         'Your name must contain only the following characters: [A-Z][a-z].';
                                    //   });
                                    //   return null;
                                    // }
                                  } on RangeError {
                                    setState(() {
                                      incorrectlyFormattedErrorMsg = '';
                                    });
                                    return null;
                                  }
                                }

                                var formattedName = formatName(controller.text);

                                if (formattedName is String) {
                                  setState(() {
                                    emptyNameErrorMsg = '';
                                  });
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  User? currentUser = auth.currentUser;

                                  // Comment for debug mode
                                  if (emptyNameErrorMsg.isEmpty &&
                                      incorrectlyFormattedErrorMsg.isEmpty) {
                                    updateUserInfo(
                                        currentUser, controller.text);
                                    Navigator.pushNamed(
                                        context, '/onboarding-dob');
                                  }
                                } else {
                                  setState(() {
                                    emptyNameErrorMsg =
                                        'Please enter a name to continue.';
                                  });
                                }
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
