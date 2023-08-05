import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/button.dart';

bool firstRun = true;

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
            child: SlideFadeTransition(
                animationDuration: const Duration(milliseconds: 1000),
                offset: 2,
                child: Text(
                  'hatched',
                  style: GoogleFonts.openSans(
                      fontSize: 70,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 10.0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
          ),
          AnimatedButton(
              landingPage: '/onboarding',
              width: MediaQuery.of(context).size.width / 1.75,
              height: MediaQuery.of(context).size.height / 20,
              buttonText: 'Create account',
              backgroundColor: const MaterialColor(0xFFFFFFFF, <int, Color>{
                50: Color(0xFFFFFFFF),
              }),
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
                Navigator.pushNamed(context, '/hobbies');
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

enum Direction { vertical, horizontal }

class SlideFadeTransition extends StatefulWidget {
  ///The child on which to apply the given [SlideFadeTransition]
  final Widget child;

  ///The offset by which to slide and [child] into view from [Direction].
  ///Defaults to 0.2
  final double offset;

  ///The curve used to animate the [child] into view.
  ///Defaults to [Curves.easeIn]
  final Curve curve;

  ///The direction from which to animate the [child] into view. [Direction.horizontal]
  ///will make the child slide on x-axis by [offset] and [Direction.vertical] on y-axis.
  ///Defaults to [Direction.vertical]
  final Direction direction;

  ///The delay with which to animate the [child]. Takes in a [Duration] and
  /// defaults to 0.0 seconds
  final Duration delayStart;

  ///The total duration in which the animation completes. Defaults to 800 milliseconds
  final Duration animationDuration;

  SlideFadeTransition({
    required this.child,
    this.offset = 0.2,
    this.curve = Curves.easeIn,
    this.direction = Direction.vertical,
    this.delayStart = const Duration(seconds: 0),
    this.animationDuration = const Duration(milliseconds: 800),
  });
  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animationSlide;

  late AnimationController _animationController;

  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    //configure the animation controller as per the direction
    if (widget.direction == Direction.vertical) {
      _animationSlide = Tween<Offset>(
              begin: Offset(0, widget.offset), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    } else {
      _animationSlide = Tween<Offset>(
              begin: Offset(widget.offset, 0), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    }

    _animationFade =
        Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      curve: widget.curve,
      parent: _animationController,
    ));

    Timer(widget.delayStart, () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('first run ${firstRun}');
    return firstRun
        ? FadeTransition(
            opacity: _animationFade,
            child: widget.child,
          )
        : widget.child;
  }
}
