import 'package:cloud_firestore/cloud_firestore.dart';
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
                var inboxList = snapshot.data!.docs.toList();
                return ListView(
                    children: inboxList.map((DocumentSnapshot document) {
                  var query = users.where('receiver_id',
                      isEqualTo: 'a3IXF0jBT0SkVW53hCIksmfsqAh2');

                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  getMessagePreviewByReceiverId(String receiverId) {
                    Stream<QuerySnapshot<Map<String, dynamic>>>
                        messagePreviews = FirebaseFirestore.instance
                            .collection('messages')
                            .where('receiver_id', isEqualTo: receiverId)
                            .snapshots();
                    return messagePreviews;
                  }

                  return StreamBuilder(
                    stream: getMessagePreviewByReceiverId(
                        'a3IXF0jBT0SkVW53hCIksmfsqAh2'),
                    builder: (context, childSnapshot) {
                      return ListTile(
                          title: Message(
                              senderId: 3,
                              receiverId: 4,
                              msgPreview: childSnapshot.data?.docs[0]
                                      ['content'] ??
                                  'test',
                              name: data['first_name'].toString()));
                    },
                  );
                }).toList());
              }),
        ),
      ],
    ));
  }
}

class Message extends StatelessWidget {
  final int senderId;
  final int receiverId;
  final String name;
  final String msgPreview;

  const Message(
      {super.key,
      required this.senderId,
      required this.receiverId,
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
          MaterialPageRoute(builder: (context) => ChatContent()),
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
                    Text(name,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700)),
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
