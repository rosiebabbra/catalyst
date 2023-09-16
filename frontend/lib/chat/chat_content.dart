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
  Future<List<Map<String, String>>> fetchMessages() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('messages').get();

      List<Map<String, String>> messages = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Access the "content" field in each document
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String? content = data['content'] as String?;
          String senderId = data['sender_id'].toString();
          String receiverId = data['receiver_id'].toString();
          Timestamp timestamp = data['timestamp'] as Timestamp;

          messages.add({
            'content': content ?? '',
            'senderId': senderId,
            'receiverId': receiverId,
            'timestamp': timestamp.toDate().toString(),
          });
        }
      }

      return messages;
    } catch (e) {
      // Handle exceptions here, e.g., log the error or return an empty list.
      print('Error fetching messages: $e');
      return [];
    }
  }

  final int _limit = 20;

  // TODO: Query for the name associated with the senderId; hardcoding until it's build
  // getSenderName() {}
  String senderName = 'Jack';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(senderName)),
        body: Column(
          children: [
            FutureBuilder(
              future: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the Future is still running, show a loading indicator
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // If there's an error, show an error message
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // If no data is available, show a message indicating no data
                  return Center(child: Text('No data available'));
                } else {
                  // Data is available, build your widget tree with it
                  List<Map<String, String>> data = snapshot.data!;

                  // Sort messages by time
                  data.sort(
                      (a, b) => a['timestamp']!.compareTo(b['timestamp']!));

                  // Use 'data' to build your widget, for example:
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        final User? currentUser = auth.currentUser;
                        final currentUserId = currentUser?.uid;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                          elevation: 5, // Adjust the elevation for shadow
                          margin: const EdgeInsets.all(
                              10.0), // Adjust the margin as needed
                          child: ListTile(
                            tileColor:
                                data[index]['receiverId'] == currentUserId
                                    ? Colors.red
                                    : Colors.blue,
                            subtitle: Padding(
                              padding:
                                  data[index]['receiverId'] == currentUserId
                                      ? const EdgeInsets.fromLTRB(200, 0, 0, 0)
                                      : const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Text(data[index]['timestamp'] ?? ''),
                            ),
                            title: Padding(
                              padding:
                                  data[index]['receiverId'] == currentUserId
                                      ? const EdgeInsets.fromLTRB(200, 0, 0, 0)
                                      : const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child:
                                  Text(data[index]['content'] ?? 'No content'),
                            ),
                            // subtitle: Text(data[index]['timestamp'] ?? ''),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const Expanded(
                    child: TextField(
                      maxLength: 1000,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Multi-line Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 25, 25),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: () {}, child: Text('Send'))),
            )
          ],
        ));
  }
}
