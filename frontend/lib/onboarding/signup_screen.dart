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
  var validEmailErrorMsg = '';
  var userExistsErrorMsg = '';
  final formatShakeKey = GlobalKey<ShakeWidgetState>();
  final matchShakeKey = GlobalKey<ShakeWidgetState>();
  var obscureTextChecked = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordReEntryController = TextEditingController();

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
                    const Text('Welcome to ',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Your email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscureTextChecked,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password_sharp),
                      labelText: 'Your password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    controller: passwordReEntryController,
                    obscureText: obscureTextChecked,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password_sharp),
                      labelText: 'Re-enter your password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Checkbox(
                      value: !obscureTextChecked,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xff33D15F);
                        }
                        return Colors.transparent;
                      }),
                      onChanged: (value) {
                        setState(() {
                          obscureTextChecked = !obscureTextChecked;
                        });
                      },
                    ),
                    const Text(
                      'Show password?',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userExistsErrorMsg.isNotEmpty)
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.red),
                    if (userExistsErrorMsg.isNotEmpty) const Text(' '),
                    Expanded(
                      child: Text(
                        userExistsErrorMsg,
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
                    if (validEmailErrorMsg.isNotEmpty)
                      const SizedBox(height: 10),
                    if (validEmailErrorMsg.isNotEmpty)
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.red),
                    if (validEmailErrorMsg.isNotEmpty) const Text(' '),
                    Text(
                      validEmailErrorMsg,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    if (passwordFormatErrorMsg.isNotEmpty)
                      const SizedBox(height: 5),
                    if (passwordFormatErrorMsg.isNotEmpty)
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.red),
                    if (passwordFormatErrorMsg.isNotEmpty) const Text(' '),
                    Text(
                      passwordFormatErrorMsg,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    if (unMatchingPasswordsErrorMsg.isNotEmpty)
                      const SizedBox(height: 5),
                    if (unMatchingPasswordsErrorMsg.isNotEmpty)
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.red),
                    if (unMatchingPasswordsErrorMsg.isNotEmpty) const Text(' '),
                    Text(
                      unMatchingPasswordsErrorMsg,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
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

                                Future<dynamic> userExists(String email) async {
                                  try {
                                    List<String> signInMethods =
                                        await FirebaseAuth.instance
                                            .fetchSignInMethodsForEmail(email);

                                    if (signInMethods.isNotEmpty) {
                                      return true;
                                      // Email is already registered; signInMethods contains the sign-in methods
                                    } else {
                                      return false;
                                      // Email is not registered
                                    }
                                  } catch (e) {
                                    setState(() {
                                      userExistsErrorMsg =
                                          "An error occurred. Please check your network settings or try again later.";
                                    });
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

                                // Write a function that determines whether
                                // a user with this email already exists in the db;
                                // if it does, render an error message that says that
                                // they have already registered and do not allow
                                // them to create an account
                                if (isExistingUser == true) {
                                  setState(() {
                                    userExistsErrorMsg =
                                        "It looks like you've already registered! Head to the login page to log in to your account.";
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
                                    !isExistingUser) {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  Navigator.pushNamed(
                                      context, '/onboarding-name');
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
