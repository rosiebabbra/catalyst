import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class HobbyScreen extends StatefulWidget {
  String hobby;
  HobbyScreen({super.key, required this.hobby});

  @override
  HobbyScreenState createState() => HobbyScreenState();
}

class HobbyScreenState extends State<HobbyScreen> {
  int counter = 4;
  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController _cardController =
        SwipeableCardSectionController();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SwipeableCardsSection(
            cardController: _cardController,
            context: context,
            items: [
              Text('Tennis',
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Colors.black,
                  )),
              Text('Golf',
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            ],
            onCardSwiped: (dir, index, widget) {
              if (counter <= 20) {
                _cardController.addItem(Text('Card stack $counter'));
                counter++;
              }
            },
          ),
        ));
  }
}
