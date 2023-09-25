import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController passwordReEntryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Your email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: passwordReEntryController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Re-enter your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  passwordFormatErrorMsg,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  unMatchingPasswordsErrorMsg,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                  onPressed: () {
                    if (passwordController.text.length <= 8) {
                      setState(() {
                        passwordFormatErrorMsg =
                            'Your password must be at least 8 characters';
                      });
                    }

                    if (passwordReEntryController.text ==
                        passwordController.text) {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.pushNamed(context, '/onboarding-name');
                    } else {
                      setState(() {
                        unMatchingPasswordsErrorMsg =
                            "The passwords entered do not match!";
                      });
                    }
                  },
                  child: const Text('Next'))
            ],
          ),
        ));
  }
}
