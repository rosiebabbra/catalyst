import 'package:flutter/material.dart';

// Since this is almost the same thing as gender_identification_screen.dart, optimize later

class IdealDateScreen extends StatefulWidget {
  const IdealDateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<IdealDateScreen> createState() => _IdealDateScreenState();
}

class _IdealDateScreenState extends State<IdealDateScreen> {
  bool coffeeChecked = false;
  bool dinsChecked = false;
  bool drinksChecked = false;
  bool rockClimbingChecked = false;
  bool karaokeChecked = false;
  bool hikingChecked = false;
  bool workoutChecked = false;
  bool otherChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(0xffEC1649);
      }
      return Color(0xffEC1649);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My ideal date is...',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: coffeeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        coffeeChecked = value!;
                      });
                    },
                  ),
                  const Text('Grabbing coffee')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: dinsChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        dinsChecked = value!;
                      });
                    },
                  ),
                  const Text('A dinner date')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: drinksChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        drinksChecked = value!;
                      });
                    },
                  ),
                  const Text('Getting drinks')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: rockClimbingChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        rockClimbingChecked = value!;
                      });
                    },
                  ),
                  const Text('Rock climbing')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: karaokeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        karaokeChecked = value!;
                      });
                    },
                  ),
                  const Text('Karaoke')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: hikingChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        hikingChecked = value!;
                      });
                    },
                  ),
                  const Text('Hiking')
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: otherChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        otherChecked = value!;
                      });
                    },
                  ),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const TextField(
                          maxLength: 25,
                          decoration: InputDecoration(hintText: 'Other')))
                ],
              ),
              TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('>> '),
                    Text('Next'),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding-ideal-match');
                },
              )
            ],
          ),
        ));
  }
}
