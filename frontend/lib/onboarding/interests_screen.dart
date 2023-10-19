import 'package:flutter/material.dart';
import 'dart:math' as math;

class Interests {
  final String interest;

  Interests(this.interest);
}

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

bool _isSelected = false;

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<int> _selectedItems = <int>{};
  bool _showVisibilityWidget = false;
  final shakeKey = GlobalKey<ShakeWidgetState>();

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // TODO: Remove duplicates
  List<Interests> myDataList = [
    Interests("Movies"),
    Interests("Music"),
    Interests("Reading"),
    Interests("Writing"),
    Interests("Video games"),
    Interests("Cooking"),
    Interests("Traveling"),
    Interests("Hiking"),
    Interests("Photography"),
    Interests("Art"),
    Interests("Coffee"),
    Interests("Yoga"),
    Interests("Meditation"),
    Interests("Gardening"),
    Interests("Basketball"),
    Interests("Football"),
    Interests("Social media"),
    Interests("Pop culture"),
    Interests("Fashion"),
    Interests("Makeup"),
    Interests("Shopping"),
    Interests("Foodie"),
    Interests("Crafting"),
    Interests("Camping"),
    Interests("Fishing"),
    Interests("Skiing"),
    Interests("Snowboarding"),
    Interests("Surfing"),
    Interests("Skateboarding"),
    Interests("Gaming"),
    Interests("Anime"),
    Interests("Manga"),
    Interests("Cosplaying"),
    Interests("Comic books"),
    Interests("Board games"),
    Interests("Card games"),
    Interests("Coding"),
    Interests("Fashion"),
    Interests("Volunteering"),
    Interests("Environmentalism"),
    Interests("Politics"),
    Interests("Self-improvement"),
    Interests("Entrepreneurship"),
    Interests("Investing"),
    Interests("Travel")
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('What are you into?',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("Don't be shy! We'll use this to find you the best matches.",
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(
              height: 10,
            ),
            Divider(thickness: 3, color: Colors.grey[350]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: myDataList.length,
                  itemBuilder: (context, index) {
                    final Interests data = myDataList[index];
                    final isSelected = _selectedItems.contains(index);
                    return TextButton(
                      style: ButtonStyle(
                          foregroundColor: isSelected
                              ? MaterialStateProperty.all<Color>(Colors.grey)
                              : MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: isSelected
                              ? MaterialStateProperty.all<Color>(
                                  Colors.grey[300]!)
                              : MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                  side: const BorderSide(color: Colors.grey)))),
                      onPressed: () => {
                        setState(() {
                          _toggleSelection(index);
                        })
                      },
                      child: Text(
                        data.interest,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 4 / 1,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 50.0, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: _showVisibilityWidget,
                    child: ShakeWidget(
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 500),
                      key: shakeKey,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(
                          'Please select at least 5 items to continue.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
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
                            onPressed: () {
                              setState(() {
                                _showVisibilityWidget = true;
                              });
                              if (_selectedItems.length > 4) {
                                Navigator.pushNamed(context, '/hobbies');
                              }
                              shakeKey.currentState?.shake();
                            },
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);
  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: animationController,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        final sineValue = math
            .sin(widget.shakeCount * 2 * math.pi * animationController.value);
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(sineValue.clamp(5, 10) * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }
}
