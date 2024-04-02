import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

convertTimestampToTime(timestamp) {
  var dt = timestamp.toDate();
  String formattedTime = DateFormat.jm().format(dt);
  return formattedTime;
}

class ChatContent extends StatefulWidget {
  final senderData; // contains sender name, id
  final String? receiverId;
  const ChatContent({Key? key, this.receiverId, this.senderData})
      : super(key: key);

  @override
  State<ChatContent> createState() => ChatContentState();
}

class ChatContentState extends State<ChatContent> {
  String timestamp = '';
  bool timestampDisplayed = false;
  int tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
        FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: widget.senderData['senderId'])
            .where('receiver_id', isEqualTo: widget.receiverId)
            .orderBy('timestamp')
            .snapshots();

    TextEditingController messageController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final currentUserId = user?.uid;

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.white,
          title: Text(widget.senderData['senderName'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
        ),
        body: Column(children: [
          Expanded(
            flex: 4,
            child: StreamBuilder(
                stream: querySnapshot,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    var msgList = snapshot.data!.docs.toList();
                    return ListView.builder(
                      itemCount: msgList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = msgList[index];
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String timestamp =
                            convertTimestampToTime(data['timestamp'])
                                .toString();

                        return Padding(
                          padding: data['receiver_id'] == currentUserId
                              ? const EdgeInsets.fromLTRB(200, 0, 0, 0)
                              : const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Card(
                            color: data['receiver_id'] == currentUserId
                                ? const Color(0xff7301E4)
                                : Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: timestampDisplayed &&
                                        tappedIndex == index
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Text(data['content'].toString(),
                                            style: TextStyle(
                                                color: data['receiver_id'] ==
                                                        currentUserId
                                                    ? Colors.white
                                                    : Colors.black)),
                                      )
                                    : Text(data['content'].toString(),
                                        style: TextStyle(
                                            color: data['receiver_id'] ==
                                                    currentUserId
                                                ? Colors.white
                                                : Colors.black)),
                              ),
                              onTap: () {
                                setState(() {
                                  if (tappedIndex == index) {
                                    tappedIndex = -1; // Reset if tapped again
                                  } else {
                                    tappedIndex = index; // Set the tapped index
                                  }
                                  timestampDisplayed = !timestampDisplayed;
                                });
                              },
                              subtitle: timestampDisplayed &&
                                      tappedIndex == index
                                  ? Padding(
                                      padding:
                                          data['receiver_id'] == currentUserId
                                              ? const EdgeInsets.fromLTRB(
                                                  15, 0, 0, 0)
                                              : const EdgeInsets.fromLTRB(
                                                  15, 0, 0, 0),
                                      child: Text(timestamp,
                                          style: TextStyle(
                                              color: data['receiver_id'] ==
                                                      currentUserId
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  : Container(),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: messageController,
              maxLines: null,
              maxLength: 1000, // Set the maximum number of characters here
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('messages').add({
                  'content': messageController.text,
                  'timestamp': Timestamp.now(),
                  'receiver_id': widget.receiverId,
                  'sender_id': currentUserId.toString()
                });
                setState(() {
                  messageController.text = '';
                });
              },
              child: const Text('Send'))
        ]));
  }
}
