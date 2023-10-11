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
                controller: controller,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Enter first name',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(children: [
                if (emptyNameErrorMsg.isNotEmpty)
                  const Icon(Icons.info_outline, size: 20, color: Colors.red),
                if (emptyNameErrorMsg.isNotEmpty) const Text(' '),
                Text(emptyNameErrorMsg,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(
                height: 30,
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
                                if (controller.text.isNotEmpty) {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  User? currentUser = auth.currentUser;
                                  updateUserInfo(currentUser, controller.text);
                                  Navigator.pushNamed(
                                      context, '/onboarding-dob');
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
