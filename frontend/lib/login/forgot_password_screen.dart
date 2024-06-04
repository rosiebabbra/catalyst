import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalyst/utils/text_fade.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  String errorMsg = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> doesEmailExist(String email) async {
    // Reference to the "users" collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Query to check if a document with the specified email exists
    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    // If there are any documents with the specified email, it exists
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> _resetPassword(String email) async {
    var emailExists = await doesEmailExist(email);
    if (emailExists) {
      await auth.sendPasswordResetEmail(email: email);
    } else {
      setState(() {
        errorMsg = "There is no account associated with the provided email.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(45.0, 0, 65.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black, // Set border color
                            width: 3.0),
                        borderRadius: BorderRadius.circular(36)),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 25.0,
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 36.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text("Forgot your password?",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Flexible(
                    child: FadeInText(
                      child: Text(
                          'No problem. Enter your email to receive a six digit number verification code.'),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              TextField(
                controller: controller,
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (errorMsg.isNotEmpty) const SizedBox(height: 5),
                    if (errorMsg.isNotEmpty)
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.red),
                    if (errorMsg.isNotEmpty) const Text(' '),
                    Expanded(
                      child: Text(
                        errorMsg,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (errorMsg.isNotEmpty) const SizedBox(height: 35),
                  ],
                ),
              ),
              Row(
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
                              // TODO: Commenting out since we know this works - set a flag to
                              // not call `_resetPassword` in debug/dev mode, but to call in prod
                              _resetPassword(controller.text);
                              // Make sure entered email exists in firestore
                              Navigator.pushNamed(
                                  context, '/password-reset-landing-page');
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
