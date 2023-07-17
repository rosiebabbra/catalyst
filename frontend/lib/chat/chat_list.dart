import 'package:flutter/material.dart';

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
          child: ListView(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), children: [
            Message(),
            Message(),
            Message(),
            Message(),
            Message(),
            Message(),
            Message(),
            Message()
          ]),
        ),
      ],
    ));
  }
}

class Message extends StatelessWidget {
  const Message({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                  Text("Hey! How's it going?", style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
