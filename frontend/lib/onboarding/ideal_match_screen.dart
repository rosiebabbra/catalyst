
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

// Since this is almost the same thing as gender_identification_screen.dart, optimize later

class IdealMatchScreen extends StatefulWidget {
  const IdealMatchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<IdealMatchScreen> createState() => _IdealMatchScreenState();
}

class Industry {
  final int id;
  final String name;

  Industry({
    required this.id,
    required this.name,
  });
}

class _IdealMatchScreenState extends State<IdealMatchScreen> {
  static final List<Industry> _industries = [
    Industry(id: 1, name: "Healthcare"),
    Industry(id: 2, name: "Technology")];
  final _items = _industries
      .map((industry) => MultiSelectItem<Industry>(industry, industry.name))
      .toList();

  @override
  Widget build(BuildContext context) {


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
                  'My ideal match works in...',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              MultiSelectDialogField(
                items: _items,
                title: const Text("Animals"),
                selectedColor: const Color(0xff7301E4),
                decoration: BoxDecoration(
                  color: const Color(0xff7301E4).withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: const Color(0xff7301E4),
                    width: 2,
                  ),
                ),
                buttonText: const Text(
                  "Select an industry",
                  style: TextStyle(
                    color: Color(0xff7301E4),
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  //_selectedAnimals = results;
                },
              ),
              TextButton(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('>> '),
                    Text('Next'),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/generating-matches');
                },
              )
            ],
          ),
        ));
  }
}