import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/matches/match_screen.dart';

updateMatches(userId) async {
  // TODO: Build a function that checks if there are any new matches
  // within 15 miles of the user's nearest metropolitan city.
  // ***
  // This workflow works upon the assumption that matches are generated
  // on swipe to users that are deemed to have met the location criteria
  // and have the same interest.
  // ***
  // - Get all matches for the user.
  // - Surface all matches in the Inbox, sorted by message sent or received recency.
  // 1. Query the matches table to get all the match IDs for the users
  //    who current user is matched with
  // 2. Then, query the users table with all user IDs that are in the matches results
  //    to get all the user IDs who meet the location criteria
  // 2.  if there are any user IDs that have the same
  //    interests as current user's that are NOT already matches. If yes, surface them
  //    users in the current user's inbox.

  queryMatches(String field1, field2) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where(field1, isEqualTo: userId)
        .get();

    var fieldValues =
        querySnapshot.docs.map((doc) => doc.data()[field2]).toList();

    return fieldValues;
  }

  // Perform queries for each condition
  final user1Matches = await queryMatches('user_1_id', 'user_2_id');
  final user2Matches = await queryMatches('user_2_id', 'user_1_id');

  // Combine results and remove duplicates
  var user1Ids = user1Matches.map((map) => map['user_1_id']).toSet().toList();
  var user2Ids = user2Matches.map((map) => map['user_2_id']).toSet().toList();

  var existingMatches = user1Ids + user2Ids;
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  User? _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<dynamic> userFuture;
  dynamic userData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String? currentUserId = auth.currentUser?.uid;
    if (currentUserId != null) {
      userFuture = getUserData(currentUserId); // Assign and fetch the future
      userData =
          await userFuture; // Await the future to complete and get the data
    }
  }

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
                                // TODO: UNCOMMENT FOR RELEASE
                                UserCredential userCredential =
                                    await auth.signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                setState(() {
                                  _user = userCredential.user;
                                });
                                if (widget.versionId == 'beta') {
                                  Navigator.pushNamed(context, '/coming-soon');
                                } else {
                                  // TODO: Run updateMatches function here in order for the user to have new matches once they are logged in.
                                  var location = userData['location'];
                                  print(location.latitude);
                                  print(location.longitude);
                                  updateMatches(userData['user_id'])
                                      .then((result) {
                                    print(result);
                                  }).catchError((error) {
                                    print(error);
                                  });
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
