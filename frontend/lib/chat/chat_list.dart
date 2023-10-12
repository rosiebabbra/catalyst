import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_content.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override

  // TODO: Sort the list by latest message recency
  // TODO: Render the most recently sent message by either party in the
  // respective chat in the Message widget
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Stream<QuerySnapshot<Object?>> querySnapshot = users.snapshots();

    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 75,
        ),
        const Center(
            child: Text(
          'Messages',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        )),
        Flexible(
          child: StreamBuilder(
              stream: querySnapshot,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show a loading indicator
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If an error occurs, display an error message
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  // If there's no data, show a message indicating an empty state
                  return const Text('No data available.');
                }

                var inboxList = snapshot.data!.docs.toList();
                return ListView(
                    children: inboxList.map((DocumentSnapshot document) {
                  Future<Object> getAllSenderIds(String receiverId) async {
                    //get all sender ids where receiver id is current user
                    QuerySnapshot senderIds = await FirebaseFirestore.instance
                        .collection('messages')
                        .where('receiver_id', isEqualTo: receiverId)
                        .get();

                    var allSenderIds = [];

                    if (senderIds.docs.isNotEmpty) {
                      // Iterate through the documents and access data from a specific column
                      for (QueryDocumentSnapshot document in senderIds.docs) {
                        var columnData = document
                            .get('sender_id'); // Replace with your column name
                        allSenderIds.add(columnData.toString());
                      }
                      return allSenderIds.toSet().toList();
                    } else {}

                    return senderIds;
                  }

                  Future<String> getMessagePreview(
                      String receiverId, String senderId) async {
                    // need to be able to differentiate by sender_id
                    QuerySnapshot messagePreviews = await FirebaseFirestore
                        .instance
                        .collection('messages')
                        .where('receiver_id', isEqualTo: receiverId)
                        .where('sender_id', isEqualTo: senderId)
                        .orderBy('timestamp', descending: true)
                        .get();

                    var msgPreview = messagePreviews.docs.first['content'];
                    return msgPreview;
                  }

                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user = auth.currentUser;

                  var senderIds = getAllSenderIds(user.toString());

                  return FutureBuilder<Object>(
                      future: senderIds,
                      builder: (BuildContext context,
                          AsyncSnapshot senderIdSnapshot) {
                        if (senderIdSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Loading indicator
                        }
                        if (senderIdSnapshot.hasError) {
                          return Text('Error: ${senderIdSnapshot.error}');
                        }
                        if (!senderIdSnapshot.hasData) {
                          return const Text('No sender IDs available.');
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                            itemCount: senderIdSnapshot.data.length,
                            itemBuilder: (BuildContext context, index) {
                              var messagePreview = getMessagePreview(
                                  'a3IXF0jBT0SkVW53hCIksmfsqAh2',
                                  senderIdSnapshot.data[index]);
                              return FutureBuilder(
                                future: messagePreview,
                                builder: (BuildContext context,
                                    AsyncSnapshot msgPreviewSnapshot) {
                                  if (msgPreviewSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Loading indicator
                                  }
                                  if (msgPreviewSnapshot.hasError) {
                                    return Text(
                                        'Error: ${msgPreviewSnapshot.error}');
                                  }
                                  if (!msgPreviewSnapshot.hasData) {
                                    return const Text(
                                        'No sender IDs available.');
                                  }

                                  getUserName(String senderId) async {
                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection(
                                                'users') // Replace with your collection name
                                            .where('user_id',
                                                isEqualTo: senderId)
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      // Iterate through the documents (there may be multiple matching records)
                                      for (QueryDocumentSnapshot document
                                          in querySnapshot.docs) {
                                        var recordData = document.data()
                                            as Map<String, dynamic>;
                                        return recordData['first_name'];
                                      }
                                    } else {
                                      return 'Error rendering user name';
                                    }
                                  }

                                  return FutureBuilder(
                                    future: getUserName(
                                        senderIdSnapshot.data[index]),
                                    builder:
                                        (BuildContext context, nameSnapshot) {
                                      if (nameSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(); // Loading indicator
                                      }
                                      if (nameSnapshot.hasError) {
                                        return Text(
                                            'Error: ${nameSnapshot.error}');
                                      }
                                      if (!nameSnapshot.hasData) {
                                        return const Text(
                                            'No sender IDs available.');
                                      }
                                      return Message(
                                          msgPreview: msgPreviewSnapshot.data,
                                          name: nameSnapshot.data);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      });
                }).toList());
              }),
        ),
      ],
    ));
  }
}

class Message extends StatelessWidget {
  // final int senderId;
  // final int receiverId;
  final String name;
  final String msgPreview;

  const Message(
      {super.key,
      // required this.senderId,
      // required this.receiverId,
      required this.name,
      required this.msgPreview});

  // Get senderId's image and their messages from the db

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // String format in the user and sender ids to get all the messages
        // then sort chronologically
        // Navigator.pushNamed(context, '/chat-content-$senderId-to-$receiverId');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatContent()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
            )),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/erin.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    color: const Color(0xff7301E4),
                    width: 2.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(msgPreview,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
