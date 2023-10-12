import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:my_app/utils/text_fade.dart';

class SeeYouSoonScreen extends StatelessWidget {
  const SeeYouSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.45),
          FadeInText(child: const SeeYouSoonMessage()),
          SizedBox(height: 15),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          SizedBox(
            height: 25,
            child: FadeInText(
              delayStart: Duration(seconds: 5),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text(
                  "Return to home page",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class SeeYouSoonMessage extends StatefulWidget {
  const SeeYouSoonMessage({
    Key? key,
  }) : super(key: key);

  @override
  State<SeeYouSoonMessage> createState() => _SeeYouSoonMessageState();
}

class _SeeYouSoonMessageState extends State<SeeYouSoonMessage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
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
      child: Center(
        child: const Text(
          'hatched',
          style: TextStyle(
            fontSize: 68.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
