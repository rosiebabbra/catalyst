import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/onboarding/interests_screen.dart';

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailErrorMessage = '';
  String passwordErrorMessage = '';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final shakeKey = GlobalKey<ShakeWidgetState>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ShaderMask(
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
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 44.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "We're glad to see you.",
                        style: TextStyle(color: Colors.grey[800], fontSize: 20),
                      )),
                  const SizedBox(height: 25),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Your email',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        emailErrorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        labelText: 'Your password',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ShakeWidget(
                        shakeCount: 3,
                        shakeOffset: 10,
                        shakeDuration: const Duration(milliseconds: 500),
                        key: shakeKey,
                        child: Text(
                          passwordErrorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        // fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text('Remember me?', style: TextStyle(fontSize: 15))
                    ],
                  ),
                  const SizedBox(height: 25),
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
                                onPressed: () async {
                                  try {
                                    // TODO: Enable for prod
                                    // await auth.signInWithEmailAndPassword(
                                    //     email: emailController.text,
                                    //     password: passwordController.text);
                                    if (widget.versionId == 'beta') {
                                      Navigator.pushNamed(
                                          context, '/coming-soon');
                                    } else {
                                      Navigator.pushNamed(context, '/hobbies');
                                    }
                                  } catch (e) {
                                    if (e is FirebaseAuthException) {
                                      if (e.code == 'invalid-email') {
                                        // Handle the 'invalid-email' error
                                        setState(() {
                                          emailErrorMessage =
                                              'Invalid email address format';
                                        });
                                      } else if (e.code == 'wrong-password') {
                                        // Handle the 'wrong-password' error
                                        setState(() {
                                          passwordErrorMessage =
                                              'Invalid password';
                                        });
                                      } else if (e.code == 'user-not-found') {
                                        setState(() {
                                          passwordErrorMessage =
                                              "You haven't registered yet!";
                                        });
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 55),
                  SizedBox(
                    height: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: const Text(
                        "Forgot your password?",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account yet? ",
                          style: TextStyle(fontSize: 15)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/onboarding-signup');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                        ),
                        child: const Text(
                          "Register now",
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class LoginScreen extends StatefulWidget {
  final String versionId;
  const LoginScreen({super.key, required this.versionId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
