import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/home_screen.dart';
import '../utils/animated_background.dart';
import '../utils/text_fade.dart';
import '../widgets/button.dart';

// TODO: Fix up styling and add a cute animation

class SwipesCompletedScreen extends StatelessWidget {
  const SwipesCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Stack(children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              FadeInText(
                animationDuration: const Duration(milliseconds: 1000),
                offset: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: Text("You're out of swipes for today.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontSize: 32,
                        color: Colors.black,
                      )),
                ),
              ),
              FadeInText(
                animationDuration: const Duration(milliseconds: 3000),
                offset: 2,
                child: Text(
                    "Don't worry, we've tee'd up some good ones for you tomorrow.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Color.fromARGB(255, 99, 95, 95),
                    )),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Stack(children: [
                AnimatedButton(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 20,
                    backgroundColor:
                        const MaterialColor(0xFF000000, <int, Color>{
                      50: Color(0xFFFFFFFF),
                    }),
                    foregroundColor:
                        const MaterialColor(0xFFFFFFFF, <int, Color>{
                      50: Color(0x00000000),
                    }),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/subscription-page')},
                    buttonText: 'Upgrade for unlimited swipes ❯'),
              ])
            ],
          ),
        ),
      ])
    ]));
  }
}
