import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget animatedButtonStyle(
    width, height, label, backgroundColor, foregroundColor,
    [fontWeight]) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
        color: backgroundColor),
    child: Center(
      child: Text(label,
          style: TextStyle(
              fontWeight: fontWeight, color: foregroundColor, fontSize: 16)),
    ),
  );
}

class AnimatedButton extends StatefulWidget {
  double width;
  double height;
  String buttonText;
  MaterialColor backgroundColor;
  MaterialColor foregroundColor;
  FontWeight fontWeight;
  VoidCallback? onPressed;
  String? landingPage;

  AnimatedButton(
      {super.key,
      required this.width,
      required this.height,
      required this.buttonText,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.fontWeight,
      this.onPressed,
      this.landingPage});

  @override
  AnimatedButtonState createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: animatedButtonStyle(
            widget.width,
            widget.height,
            widget.buttonText,
            widget.backgroundColor,
            widget.foregroundColor,
            widget.fontWeight),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    Timer(const Duration(seconds: 3), () {});
    if (widget.landingPage != null) {
      Navigator.pushNamed(context, widget.landingPage.toString());
    }
  }
}

class StandardButton extends StatelessWidget {
  final double borderRadius;
  final String destination;
  final String buttonText;

  const StandardButton({
    Key? key,
    required this.destination,
    required this.buttonText,
    this.borderRadius = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.75,
        height: MediaQuery.of(context).size.height / 20,
        child: CupertinoButton(
          color: Colors.white,
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushNamed(context, destination);
          },
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          child: Text(buttonText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18)),
        ));
  }
}
