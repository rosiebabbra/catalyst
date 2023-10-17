import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/text_fade.dart';
import '../widgets/button.dart';

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.25,
          ),
          Center(
            child: FadeInText(
                animationDuration: const Duration(milliseconds: 1000),
                offset: 2,
                child: Text(
                  'catalyst',
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 72,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                        ),
                      ]),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.75,
          ),
          AnimatedButton(
              landingPage: '/onboarding-signup',
              width: MediaQuery.of(context).size.width / 1.75,
              height: MediaQuery.of(context).size.height / 20,
              buttonText: 'Create account',
              backgroundColor: const MaterialColor(0xFFFFFFFF, <int, Color>{
                50: Color(0xFFFFFFFF),
              }),
              fontSize: 16,
              foregroundColor: const MaterialColor(0xFF000000, <int, Color>{
                50: Color(0x00000000),
              }),
              fontWeight: FontWeight.w700),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(
            text: 'Sign in',
            style: const TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/login');
              },
          ))
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
