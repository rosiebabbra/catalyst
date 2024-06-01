import 'dart:async';
import 'dart:math' as math;
import 'package:catalyst/matches/match_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

String convertTimestampToDateTime(Timestamp timestamp) {
  var dt = timestamp.toDate();
  String formattedDateTime = DateFormat.yMd().add_jm().format(dt);
  return formattedDateTime;
}

class ChatContent extends StatefulWidget {
  final senderData;
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> receivedQuerySnapshot =
        FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: widget.senderData['senderId'])
            .where('receiver_id', isEqualTo: widget.receiverId)
            .snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> sentQuerySnapshot =
        FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: widget.receiverId)
            .where('receiver_id', isEqualTo: widget.senderData['senderId'])
            .snapshots();

    Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> messageStream =
        CombineLatestStream.list([receivedQuerySnapshot, sentQuerySnapshot])
            .map((List<dynamic> snapshotList) {
      // Cast each dynamic element to QuerySnapshot<Map<String, dynamic>>
      List<QuerySnapshot<Map<String, dynamic>>> snapshots = snapshotList
          .map((dynamic snapshot) =>
              snapshot as QuerySnapshot<Map<String, dynamic>>)
          .toList();

      // Merge documents from both snapshots into a single list
      List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocuments =
          snapshots.expand((snapshot) => snapshot.docs).toList();

      // Sort the combined list by timestamp
      allDocuments.sort((a, b) {
        DateTime aTimestamp = a.data()['timestamp'].toDate();
        DateTime bTimestamp = b.data()['timestamp'].toDate();
        return aTimestamp
            .compareTo(bTimestamp); // Use compareTo for ascending order
      });

      return allDocuments;
    });

    TextEditingController messageController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final currentUserId = user?.uid;

    double getFontSize(int textLength) {
      const int baseSize = 16;
      if (textLength >= baseSize) {
        textLength = baseSize - 2;
      }
      int fontSize = baseSize - textLength;
      return MediaQuery.of(context).size.width * 0.01 * fontSize;
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: AppBar(
            title: Text(widget.senderData['senderName'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        getFontSize(widget.senderData['senderName'].length),
                    fontWeight: FontWeight.bold)),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MatchScreen(
                              matchId: widget.senderData['senderId'],
                            )),
                  );
                },
                style: ButtonStyle(
                    alignment: Alignment.center,
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(children: [
                      Icon(Icons.person, color: Colors.black, size: 45),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.info,
                              color: Colors.black,
                              size: 22.5,
                            )),
                      )
                    ]),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios, color: Colors.black)
                  ],
                ),
              ),
            ],
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
          ),
        ),
        body: Column(children: [
          Expanded(
            flex: 4,
            child: StreamBuilder(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var msgList = snapshot.data!;
                    return ListView.builder(
                      key: Key("${math.Random().nextDouble()}"),
                      itemCount: msgList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = msgList[index];
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String timestamp =
                            convertTimestampToDateTime(data['timestamp'])
                                .toString();

                        return Padding(
                          padding: data['receiver_id'] == currentUserId
                              ? const EdgeInsets.fromLTRB(15, 0, 200, 0)
                              : const EdgeInsets.fromLTRB(200, 0, 15, 0),
                          child: Card(
                            color: data['receiver_id'] == currentUserId
                                ? Colors.grey[200]
                                : const Color(0xff7301E4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text(data['content'].toString(),
                                    key: Key("${math.Random().nextDouble()}"),
                                    style: TextStyle(
                                        color:
                                            data['receiver_id'] == currentUserId
                                                ? Colors.black
                                                : Colors.white)),
                              ),
                              onTap: () {
                                setState(() {
                                  if (tappedIndex == index) {
                                    tappedIndex = -1; // Reset if tapped again
                                    timestampDisplayed = false;
                                  } else {
                                    tappedIndex = index; // Set the tapped index
                                    timestampDisplayed = true;
                                  }
                                });
                              },
                              subtitle:
                                  timestampDisplayed && tappedIndex == index
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 0, 0),
                                          child: Text(timestamp,
                                              style: TextStyle(
                                                  color: data['receiver_id'] ==
                                                          currentUserId
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                      : null,
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.75,
                // height: MediaQuery.sizeOf(context).width * 0.125,
                child: TextFormField(
                  controller: messageController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                height: 65,
                width: 65,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 3.5, color: Colors.transparent),
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
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                        shape: BoxShape.rectangle,
                        color: Colors.white),
                    child: CupertinoButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('messages')
                              .add({
                            'content': messageController.text,
                            'timestamp': Timestamp.now(),
                            'receiver_id': widget.senderData['senderId'],
                            'sender_id': currentUserId
                          });
                          setState(() {
                            messageController.text = '';
                          });
                        },
                        child: const Icon(Icons.arrow_forward_ios)),
                  ),
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
          SizedBox(height: 45)
        ]));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
