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
  bool throbber = false;
  String noMessagesErrorMsg = '';

  Future<Object> getAllSenderIds(String receiverId) async {
    QuerySnapshot senderIds = await FirebaseFirestore.instance
        .collection('messages')
        .where('receiver_id', isEqualTo: receiverId)
        .get();

    var allSenderIds = [];

    if (senderIds.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in senderIds.docs) {
        var columnData = document.get('sender_id');
        allSenderIds.add(columnData.toString());
      }
      return allSenderIds.toSet().toList();
    } else {
      return allSenderIds;
    }
  }

  Future<String> getMessagePreview(String receiverId, String senderId) async {
    QuerySnapshot messagePreviews = await FirebaseFirestore.instance
        .collection('messages')
        .where('receiver_id', isEqualTo: receiverId)
        .where('sender_id', isEqualTo: senderId)
        .orderBy('timestamp', descending: true)
        .get();

    var msgPreview = messagePreviews.docs.first['content'];
    return msgPreview;
  }

  dynamic getUserName(String senderId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: senderId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        var recordData = document.data() as Map<String, dynamic>;
        return recordData['first_name'];
      }
    } else {
      return 'Error rendering user name';
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Stream<QuerySnapshot<Object?>> userSnapshots = users.snapshots();

    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 75,
        ),
        const Center(
            child: Text(
          'Inbox',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        )),
        if (throbber) const CircularProgressIndicator(color: Color(0xff33D15F)),
        if (noMessagesErrorMsg.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(noMessagesErrorMsg.toString(),
                style: const TextStyle(fontSize: 18)),
          ),
        Flexible(
          child: StreamBuilder(
              stream: userSnapshots,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show a loading indicator
                  return const CircularProgressIndicator(
                      color: Color(0xff33D15F));
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
                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user = auth.currentUser;

                  var senderIds = getAllSenderIds(user!.uid);

                  return FutureBuilder<Object>(
                      future: senderIds,
                      builder: (BuildContext context,
                          AsyncSnapshot senderIdSnapshot) {
                        if (senderIdSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          throbber = true;
                        }
                        if (senderIdSnapshot.hasError) {
                          return Text('Error: ${senderIdSnapshot.error}');
                        }
                        if (senderIdSnapshot.data == null) {
                          noMessagesErrorMsg = 'You have no messages yet!';
                        }
                        throbber = false;
                        noMessagesErrorMsg = '';

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: (senderIdSnapshot.data != null)
                              ? ListView.builder(
                                  itemCount: (senderIdSnapshot.data != null)
                                      ? senderIdSnapshot.data.length
                                      : 1,
                                  itemBuilder: (BuildContext context, index) {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    User? user = auth.currentUser;

                                    var messagePreview = getMessagePreview(
                                        user!.uid,
                                        senderIdSnapshot.data[index]);
                                    return FutureBuilder(
                                      future: messagePreview,
                                      builder: (BuildContext context,
                                          AsyncSnapshot msgPreviewSnapshot) {
                                        if (msgPreviewSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(
                                              color: Color(0xff33D15F));
                                        }
                                        if (msgPreviewSnapshot.hasError) {
                                          return Text(
                                              'Error: ${msgPreviewSnapshot.error}');
                                        }
                                        if (!msgPreviewSnapshot.hasData) {
                                          return const Text(
                                              'No sender IDs available.');
                                        }

                                        return FutureBuilder(
                                          future: getUserName(
                                              senderIdSnapshot.data[index]),
                                          builder: (BuildContext context,
                                              nameSnapshot) {
                                            if (nameSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                        color:
                                                            Color(0xff33D15F)),
                                              );
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
                                                msgPreview:
                                                    msgPreviewSnapshot.data,
                                                name: nameSnapshot.data
                                                    .toString());
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              : const Text(''),
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
          MaterialPageRoute(
              builder: (context) => const ChatContent(
                    receiverId: '4',
                  )),
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
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/dating-appp-2d438.appspot.com/o/user_images%2F32bTzSuJfwUYwSbVBGdDGk5MM5g2_1.jpg?alt=media&token=d69fa31c-5470-4e27-8081-eeb7fc49a17a'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    // color: const Color(0xff7301E4),
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
