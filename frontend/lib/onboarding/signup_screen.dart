import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/onboarding/interests_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var unMatchingPasswordsErrorMsg = '';
  var passwordFormatErrorMsg = '';
  final formatShakeKey = GlobalKey<ShakeWidgetState>();
  final matchShakeKey = GlobalKey<ShakeWidgetState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordReEntryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Text('Welcome to ',
                    style:
                        TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xff7301E4),
                        Color(0xff0E8BFF),
                        Color(0xff09CBC8),
                        Color(0xff33D15F),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'hatched',
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Text('.',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "We're so glad you're here.",
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ),
          const SizedBox(height: 45),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Your email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.password_sharp),
              labelText: 'Your password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: passwordReEntryController,
            obscureText: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.password_sharp),
              labelText: 'Re-enter your password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              passwordFormatErrorMsg,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              unMatchingPasswordsErrorMsg,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 35),
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
                          border:
                              Border.all(width: 3.5, color: Colors.transparent),
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
                            if (passwordController.text.length <= 8) {
                              setState(() {
                                passwordFormatErrorMsg =
                                    'Your password must be at least 8 characters.';
                              });
                            }

                            if (passwordReEntryController.text ==
                                passwordController.text) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              Navigator.pushNamed(context, '/onboarding-name');
                            } else {
                              setState(() {
                                unMatchingPasswordsErrorMsg =
                                    "The passwords entered do not match.";
                              });
                            }
                            formatShakeKey.currentState?.shake();
                            matchShakeKey.currentState?.shake();
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
