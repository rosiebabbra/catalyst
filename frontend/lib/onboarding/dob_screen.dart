import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DOBEntryScreen extends StatefulWidget {
  const DOBEntryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DOBEntryScreen> createState() => _DOBEntryScreenState();
}

class _DOBEntryScreenState extends State<DOBEntryScreen> {
  var m1Val = '';
  var m2Val = '';
  var d1Val = '';
  var d2Val = '';
  var y1Val = '';
  var y2Val = '';

  updateUserInfo(User? user, String birthDate) async {
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
    } else {
      print('No matching records found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController m1Controller = TextEditingController(text: '');
    TextEditingController m2Controller = TextEditingController(text: '');
    TextEditingController d1Controller = TextEditingController(text: '');
    TextEditingController d2Controller = TextEditingController(text: '');
    TextEditingController y1Controller = TextEditingController(text: '');
    TextEditingController y2Controller = TextEditingController(text: '');

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                child: const Icon(Icons.cake_outlined, size: 30),
                radius: 30,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Your birthday?",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15,
              ),
              Text('Your profile shows your age, not your date of birth.',
                  style: TextStyle(fontSize: 15, color: Colors.grey[700])),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                        showCursor: false,
                        controller: m1Controller,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        autofocus: true,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'M',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          showCursor: false,
                          controller: m2Controller,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          maxLength: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'M',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  Text('—', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          showCursor: false,
                          controller: d1Controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          maxLength: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'D',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          showCursor: false,
                          controller: d2Controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          maxLength: 1,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'D',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  Text('—', style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          showCursor: false,
                          controller: y1Controller,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Y',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              )))),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 10,
                      child: TextFormField(
                          showCursor: false,
                          controller: y2Controller,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Y',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ))))
                ],
              ),
              const SizedBox(
                height: 75,
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
                                var yyPrefix = '';
                                if (y1Controller.text == '0') {
                                  yyPrefix = '20';
                                } else {
                                  yyPrefix = '19';
                                }

                                var birthDate =
                                    '$yyPrefix${y1Controller.text}${y2Controller.text}${m1Controller.text}${m2Controller.text}${d1Controller.text}${d2Controller.text}';
                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? currentUser = auth.currentUser;
                                updateUserInfo(currentUser, birthDate);
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
