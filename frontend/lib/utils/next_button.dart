import 'dart:math' as math;
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 3.5, color: Colors.transparent),
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
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: TextButton(
          child: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/verification-code');
          },
        ),
      ),
    );
  }
}
