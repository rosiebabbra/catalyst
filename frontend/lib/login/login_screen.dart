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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      fontSize: 38.0,
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
                    style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  )),
              const SizedBox(height: 25),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Your email',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      labelText: 'Your password',
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              if (emailErrorMessage.isNotEmpty)
                const SizedBox(
                  height: 20,
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      emailErrorMessage,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (passwordErrorMessage.isNotEmpty)
                const SizedBox(
                  height: 5,
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      passwordErrorMessage,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    side: const BorderSide(
                        width: 2, color: Color.fromRGBO(97, 97, 97, 1)),
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff33D15F);
                      }
                      return Colors.transparent;
                    }),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Text('Remember me?', style: TextStyle(fontSize: 16))
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
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                await auth.signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                                if (widget.versionId == 'beta') {
                                  Navigator.pushNamed(context, '/coming-soon');
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
                                          'You have entered an invalid username or password';
                                    });
                                  } else if (e.code == 'user-not-found') {
                                    setState(() {
                                      passwordErrorMessage =
                                          "Invalid email or password";
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
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding-signup');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                ),
                child: Text(
                  "Don't have an account yet? Register now",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ));
  }
}

class LoginScreen extends StatefulWidget {
  final String versionId;
  const LoginScreen({super.key, required this.versionId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
