import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ColorConstants {
  static const themeColor = Color(0xfff5a623);
  static Map<int, Color> swatchColor = {
    50: themeColor.withOpacity(0.1),
    100: themeColor.withOpacity(0.2),
    200: themeColor.withOpacity(0.3),
    300: themeColor.withOpacity(0.4),
    400: themeColor.withOpacity(0.5),
    500: themeColor.withOpacity(0.6),
    600: themeColor.withOpacity(0.7),
    700: themeColor.withOpacity(0.8),
    800: themeColor.withOpacity(0.9),
    900: themeColor.withOpacity(1),
  };
  static const primaryColor = Color(0xff203152);
  static const greyColor = Color(0xffaeaeae);
  static const greyColor2 = Color(0xffE8E8E8);
}

class ChatContent extends StatefulWidget {
  const ChatContent({Key? key}) : super(key: key);

  @override
  State<ChatContent> createState() => ChatContentState();
}

class ChatContentState extends State<ChatContent> {
  // TODO: Query for the name associated with the senderId; hardcoding until it's build
  // getSenderName() {}
  String senderName = 'Jack';

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
        FirebaseFirestore.instance.collection('messages').snapshots();
    TextEditingController messageController = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: Text(senderName)),
        body: Column(children: [
          StreamBuilder(
              stream: querySnapshot,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                convertTimestampToDateTime(timestamp) {
                  var dt = timestamp.toDate();
                  return dt;
                }

                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final currentUserId = user?.uid;
                var msgList = snapshot.data!.docs.toList();
                msgList.sort((a, b) {
                  return a["timestamp"].compareTo(b["timestamp"]);
                });

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ListView(
                      children: msgList.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                            tileColor: data['receiver_id'] == currentUserId
                                ? Colors.red
                                : Colors.blue,
                            title: Padding(
                              padding: data['receiver_id'] == currentUserId
                                  ? const EdgeInsets.fromLTRB(200, 0, 0, 0)
                                  : const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Text(data['content'].toString()),
                            ),
                            subtitle: Padding(
                              padding: data['receiver_id'] == currentUserId
                                  ? const EdgeInsets.fromLTRB(200, 0, 0, 0)
                                  : const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Text(
                                  convertTimestampToDateTime(data['timestamp'])
                                      .toString()),
                            )),
                      ),
                    );
                  }).toList()),
                );
              }),
          TextFormField(
            controller: messageController,
            maxLines: null,
            maxLength: 1000, // Set the maximum number of characters here
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('messages').add({
                  'content': messageController.text,
                  'timestamp': Timestamp.now(),
                  'receiver_id': '4',
                  'sender_id': 'a3IXF0jBT0SkVW53hCIksmfsqAh2'
                });
              },
              child: Text('Send'))
        ]));
  }
}
