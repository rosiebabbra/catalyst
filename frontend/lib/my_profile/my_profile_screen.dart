import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String first_name = 'Loading...';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final response = await http
        .post(Uri.parse('http://127.0.0.1:8080/users'), body: {'user_id': '1'});
    if (response.statusCode == 200) {
      // Handle successful response
      final data = response.body;
      List<dynamic> jsonList = jsonDecode(data);
      print(data);

      setState(() {
        first_name = jsonList[0]['first_name'];
      });
    } else {
      throw Exception('Failed to load data from backend');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.settings, size: 30),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Stack(children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    color: Color(0xff7c94b6),
                    image: DecorationImage(
                      image: AssetImage('assets/images/profPic3.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Text(first_name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: TextButton(
                  onPressed: () {
                    getData();
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[600]!),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[100]!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ))),
                  child: const Text('Complete my profile',
                      style: TextStyle(fontSize: 12))),
            ),
            const SizedBox(height: 25),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 154, 231, 176),
                    Color(0xff33D15F),
                    Color(0xff09CBC8)
                  ]),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 0.5, color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Premium',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Flexible(
                              child: Text(
                                  'Unlock all of our features and get more matches',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        width: 185,
                        child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                ))),
                            child: const Text("Upgrade from \$1.95",
                                style: TextStyle(fontSize: 16))),
                      ),
                    ],
                  ),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 35.0, 15.0, 15.0),
              child: GridView.count(
                  shrinkWrap: false,
                  padding: const EdgeInsets.all(0),
                  crossAxisCount: 3,
                  childAspectRatio: 5 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    Text('What you get:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Premium',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Standard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    Text('Unlimited likes',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Icon(Icons.check, color: Color(0xff33D15F)),
                    Icon(Icons.check, color: Colors.grey),
                    Text('Advanced filters',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Icon(Icons.check, color: Color(0xff33D15F)),
                    Icon(Icons.check, color: Colors.grey),
                    Text('Incognito mode',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Icon(Icons.check, color: Color(0xff33D15F)),
                    Icon(Icons.check, color: Colors.grey),
                    Text('Travel mode',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Icon(Icons.check, color: Color(0xff33D15F)),
                    Icon(Icons.check, color: Colors.grey),
                  ]),
            ))
          ],
        ));
  }
}
