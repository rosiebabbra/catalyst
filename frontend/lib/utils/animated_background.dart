import 'package:flutter/material.dart';
import 'dart:math' as math;
// import 'package:animated_background/animated_background.dart';

class StarryBackgroundWidget extends StatefulWidget {
  const StarryBackgroundWidget({Key? key}) : super(key: key);

  @override
  StarryBackgroundWidgetState createState() => StarryBackgroundWidgetState();
}

class StarryBackgroundWidgetState extends State<StarryBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1, 1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value * 100, // Adjust the distance of movement
          child: child,
        );
      },
      child: Stack(
        children: [
          for (int i = 0; i < 50; i++)
            Positioned(
              top: math.Random().nextDouble() *
                  MediaQuery.of(context).size.height *
                  2,
              left: math.Random().nextDouble() *
                  MediaQuery.of(context).size.width *
                  2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.circle,
                  size: (math.Random().nextDouble() * 65).clamp(25, 65),
                  color: Color.fromRGBO(
                      math.Random().nextInt(256),
                      math.Random().nextInt(256),
                      math.Random().nextInt(256),
                      0.75),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
