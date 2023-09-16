import 'package:flutter/material.dart';

import 'chat_content.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
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
          child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              children: const [
                Message(
                  senderId: 2,
                  receiverId: 5,
                ),
                Message(
                  senderId: 3,
                  receiverId: 8,
                ),
                Message(
                  senderId: 4,
                  receiverId: 9,
                ),
                Message(
                  senderId: 5,
                  receiverId: 3,
                ),
                Message(
                  senderId: 6,
                  receiverId: 37,
                ),
                Message(
                  senderId: 7,
                  receiverId: 48,
                ),
                Message(
                  senderId: 8,
                  receiverId: 87,
                ),
                Message(
                  senderId: 9,
                  receiverId: 784,
                )
              ]),
        ),
      ],
    ));
  }
}

class Message extends StatelessWidget {
  final int senderId;
  final int receiverId;

  const Message({super.key, required this.senderId, required this.receiverId});

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
                width: 100.0,
                height: 100.0,
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
                  children: const [
                    Text('Erin',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700)),
                    Text("Hey! How's it going?",
                        style: TextStyle(fontSize: 18)),
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
