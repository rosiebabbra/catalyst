import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

Future<dynamic> getUserData(String userId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('user_id', isEqualTo: userId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      var recordData = document.data() as Map<String, dynamic>;
      return recordData;
    }
  } else {
    return {'first_name': 'Error rendering user name'};
  }
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
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Your email',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        // color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    labelText: 'Your password',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      side: const BorderSide(
                          width: 2, color: Color.fromRGBO(97, 97, 97, 1)),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xff7301E4);
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: const Text('Remember me?',
                        style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
              SizedBox(
                height: 40,
                child: Text(
                  emailErrorMessage,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 40,
                child: Text(
                  passwordErrorMessage,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
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
                                FocusManager.instance.primaryFocus?.unfocus();
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
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}

class LoginScreen extends StatefulWidget {
  final String versionId;
  const LoginScreen({super.key, required this.versionId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
