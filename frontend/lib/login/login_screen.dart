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
        body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            children: [
              const SizedBox(height: 200),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome back",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
              ),
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
                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    emailErrorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    labelText: 'Your password',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
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
              const SizedBox(height: 25),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    key: GlobalKey(debugLabel: 'loginKey'),
                    child: const Text('Login'),
                    onPressed: () async {
                      try {
                        // TODO: Enable for prod
                        // await auth.signInWithEmailAndPassword(
                        //     email: emailController.text,
                        //     password: passwordController.text);
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
                              passwordErrorMessage = 'Invalid password';
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
                ],
              ),
              const SizedBox(height: 35),
              SizedBox(
                height: 25,
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
                      style: TextStyle(fontSize: 14)),
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
