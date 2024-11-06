import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/onboarding/interests_screen.dart';
import 'package:catalyst/utils/utils.dart';

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
  var validEmailErrorMsg = '';
  var userExistsErrorMsg = '';
  var signUpErrorMsg = '';
  bool passwordIsVisible = false;
  bool confirmPasswordIsVisible = false;
  bool passwordIsObscured = true;
  bool confirmPasswordIsObscured = true;
  final formatShakeKey = GlobalKey<ShakeWidgetState>();
  final matchShakeKey = GlobalKey<ShakeWidgetState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordReEntryController = TextEditingController();

  createUserRecord(String userId, String email) {
    if (isSafeFromSqlInjection(userId) && isSafeFromSqlInjection(email)) {
      FirebaseFirestore.instance.collection('users').add(
          {'user_id': userId, 'email': email, 'created_at': DateTime.now()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Flexible(
                      child: Text('Welcome to ',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
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
                        'catalyst',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
              const SizedBox(height: 50),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Your email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: !passwordIsVisible,
                decoration: InputDecoration(
                  labelText: 'Your password',
                  suffixIcon: IconButton(
                      icon: passwordIsVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passwordIsVisible = !passwordIsVisible;
                        });
                      }),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordReEntryController,
                obscureText: !confirmPasswordIsVisible,
                decoration: InputDecoration(
                  labelText: 'Re-enter your password',
                  suffixIcon: IconButton(
                      icon: confirmPasswordIsVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          confirmPasswordIsVisible = !confirmPasswordIsVisible;
                        });
                      }),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userExistsErrorMsg.isNotEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                userExistsErrorMsg,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        validEmailErrorMsg,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        passwordFormatErrorMsg,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      unMatchingPasswordsErrorMsg,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Align(
                child: Row(
                  children: [
                    Text(signUpErrorMsg),
                  ],
                ),
              ),
              const SizedBox(height: 25),
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
                                onPressed: () async {
                                  bool invalidEmailInput(String email) {
                                    final RegExp emailRegex = RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                                    );

                                    return !emailRegex.hasMatch(email);
                                  }

                                  Future<dynamic> userExists(
                                      String email) async {
                                    try {
                                      List<String> signInMethods =
                                          await FirebaseAuth.instance
                                              .fetchSignInMethodsForEmail(
                                                  email);

                                      if (signInMethods.isNotEmpty) {
                                        return true;
                                        // Email is already registered; signInMethods contains the sign-in methods
                                      } else {
                                        return false;
                                        // Email is not registered
                                      }
                                    } catch (e) {
                                      // setState(() {
                                      //   userExistsErrorMsg =
                                      //       "An error occurred. Please check your network settings or try again later.";
                                      // });
                                    }
                                  }

                                  var isInvalidEmail =
                                      invalidEmailInput(emailController.text);
                                  var isNotMinPasswordLength =
                                      passwordController.text.length < 8;
                                  var passwordsNonMatching =
                                      passwordController.text !=
                                          passwordReEntryController.text;
                                  var isExistingUser =
                                      await userExists(emailController.text);

                                  if (isExistingUser == true) {
                                    setState(() {
                                      userExistsErrorMsg =
                                          "User already exists.";
                                    });
                                  } else {
                                    setState(() {
                                      userExistsErrorMsg = "";
                                    });
                                  }

                                  if (isInvalidEmail) {
                                    setState(() {
                                      validEmailErrorMsg =
                                          'Please enter a valid email address.';
                                    });
                                  } else {
                                    setState(() {
                                      validEmailErrorMsg = '';
                                    });
                                  }

                                  if (isNotMinPasswordLength) {
                                    setState(() {
                                      passwordFormatErrorMsg =
                                          'Your password must be at least 8 characters long.';
                                    });
                                  } else {
                                    setState(() {
                                      passwordFormatErrorMsg = '';
                                    });
                                  }

                                  if (passwordsNonMatching) {
                                    setState(() {
                                      unMatchingPasswordsErrorMsg =
                                          "The entered passwords do not match.";
                                    });
                                  } else {
                                    setState(() {
                                      unMatchingPasswordsErrorMsg = '';
                                    });
                                  }

                                  // Commenting out for debugging
                                  if (!isInvalidEmail &&
                                      !isNotMinPasswordLength &&
                                      !passwordsNonMatching &&
                                      !isExistingUser &&
                                      isSafeFromSqlInjection(
                                          emailController.text) &&
                                      isSafeFromSqlInjection(
                                          passwordController.text) &&
                                      isSafeFromSqlInjection(
                                          passwordReEntryController.text)) {
                                    UserCredential credential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    if (credential.user != null) {
                                      createUserRecord(
                                          credential.user!.uid.toString(),
                                          emailController.text);
                                    } else {
                                      setState(() {
                                        signUpErrorMsg =
                                            'There was an error creating your account.';
                                      });
                                    }

                                    Navigator.pushNamed(
                                        context, '/onboarding-name');
                                  }

                                  // formatShakeKey.currentState?.shake();
                                  // matchShakeKey.currentState?.shake();
                                  // },
                                }),
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
