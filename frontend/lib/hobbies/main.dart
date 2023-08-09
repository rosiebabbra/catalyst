import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../utils/text_fade.dart';

class HobbyScreen extends StatefulWidget {
  String hobby;
  HobbyScreen({super.key, required this.hobby});

  @override
  HobbyScreenState createState() => HobbyScreenState();
}

class HobbyScreenState extends State<HobbyScreen> {
  List<Hobby> hobbies = [
    Hobby(id: 1, name: 'Tennis'),
    Hobby(id: 2, name: 'Golf')
  ];

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController cardController =
        SwipeableCardSectionController();
    List<Card> stack = [];
    int counter = 0;

    for (var item in hobbies) {
      stack.add(
        Card(
          elevation: 0, // Set elevation to 0 to remove the shadow
          shape: RoundedRectangleBorder(
            side: BorderSide.none, // Set no borders
            borderRadius: BorderRadius.circular(0), // Set no border radius
          ),
          borderOnForeground: false,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          child: Center(
            child: FadeInText(
              child: Text(item.name,
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SwipeableCardsSection(
            enableSwipeUp: false,
            enableSwipeDown: false,
            cardHeightTopMul: 0.9,
            cardWidthTopMul: 0.9,
            cardWidthMiddleMul: 0.9,
            cardWidthBottomMul: 0.9,
            cardHeightMiddleMul: 0.9,
            cardHeightBottomMul: 0.9,
            cardController: cardController,
            context: context,
            items: [SizedBox.expand(child: stack[counter])],
            onCardSwiped: (dir, index, widget) {
              if (counter < stack.length) {
                // if (dir == Direction.right) {
                //// add to db of users' interests
                // } else {
                //// add to db of things user is NOT interested in
                // }
                //// regardless of whether the user is interested in the current
                //// card or not, after a swipe, move to the next hobby
                counter++;
                try {
                  cardController.addItem(stack[counter]);
                } on RangeError catch (e) {
                  Navigator.pushNamed(context, '/swipes-completed');
                }
              }
            },
          ),
        ));
  }
}

class Hobby {
  int id;
  String name;

  // Constructor
  Hobby({required this.id, required this.name});
}
