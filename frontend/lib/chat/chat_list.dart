import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'chat_content.dart';

double getDistanceBetweenUsers(currentUserData, potentialMatchData) {
  double distanceInMeters = Geolocator.distanceBetween(
      currentUserData['location'].latitude,
      currentUserData['location'].longitude,
      potentialMatchData['location'].latitude,
      potentialMatchData['location'].longitude);

  var distanceInMiles = distanceInMeters * 0.00062137;

  return distanceInMiles;
}

Future<bool> determineMatch(userAId, userBId) async {
  if (userAId != userBId) {
    final CollectionReference selectedInterestsCollection =
        FirebaseFirestore.instance.collection('selected_interests');

    QuerySnapshot<Object?> userAInterests = await selectedInterestsCollection
        .where('user_id', isEqualTo: userAId)
        .get();
    var userAInterestIds = [];
    if (userAInterests.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in userAInterests.docs) {
        var interest = document.get('interest_ids');
        if (interest is List) {
          userAInterestIds.addAll(interest);
        } else if (interest is String || interest is int) {
          userAInterestIds.add(interest);
        }
      }
    }

    QuerySnapshot<Object?> userBInterests = await selectedInterestsCollection
        .where('user_id', isEqualTo: userBId)
        .get();
    var userBInterestIds = [];
    if (userBInterests.docs.isNotEmpty) {
      for (QueryDocumentSnapshot document in userBInterests.docs) {
        var interest = document.get('interest_ids');
        if (interest is List) {
          userBInterestIds.addAll(interest);
        } else if (interest is String || interest is int) {
          userBInterestIds.add(interest);
        }
      }
    }

    if ((userAInterestIds.isNotEmpty) && (userBInterestIds.isNotEmpty)) {
      var commonInterests = userAInterestIds
          .toSet()
          .intersection(userBInterestIds.toSet())
          .toList();

      var currentPair = [userAId, userBId];
      currentPair.sort();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('match_ids', isEqualTo: currentPair)
          .get();

      if (querySnapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('matches').add({
          'match_ids': [userAId, userBId],
          'interest_ids': FieldValue.arrayUnion(commonInterests)
        });
      }

      return commonInterests.isEmpty ? false : true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Stream<List<dynamic>> fetchMatches(
    double currentUserLat, double currentUserLong) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final currentUserId = user?.uid;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  return usersCollection.snapshots().asyncMap((snapshot) async {
    var users =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    var potentialMatches = users.where((user) {
      double distance = getDistanceBetweenUsers(
          {'location': GeoPoint(currentUserLat, currentUserLong)}, user);
      return distance <= 15;
    }).toList();

    var matchedUsers = [];

    for (var user in potentialMatches) {
      if (await determineMatch(currentUserId, user['user_id'])) {
        matchedUsers.add(user);
      }
    }

    // Drop the current User ID from here
    matchedUsers.removeWhere((user) => user['user_id'] == currentUserId);

    return matchedUsers;
  });
}

class ChatList extends StatefulWidget {
  final List<String> userIds;

  const ChatList({Key? key, required this.userIds}) : super(key: key);

  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  bool throbber = false;
  String noMessagesErrorMsg = '';
  late String matchId;

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

  Stream<String> streamMessagePreview(
      String receiverId, String senderId, String matchName) {
    final messagePreviewQuery = FirebaseFirestore.instance
        .collection('messages')
        .where('receiver_id', isEqualTo: receiverId)
        .where('sender_id', isEqualTo: senderId)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return messagePreviewQuery.map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['content'];
      } else {
        // Return a default value if no message preview is found
        return 'Start your chat with ${matchName}!';
      }
    });
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
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: const Text(
              'Inbox',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            )),
        body: StreamBuilder(
            stream: fetchMatches(38, 90),
            builder: (BuildContext matchContext,
                AsyncSnapshot<dynamic> matchSnapshot) {
              if (matchSnapshot.hasError) {
                return const CircularProgressIndicator(color: Colors.red);
              } else {
                if (matchSnapshot.connectionState == ConnectionState.active) {
                  return Column(
                    children: [
                      Flexible(
                          flex: 12,
                          child: ListView.builder(
                              itemCount: matchSnapshot.data.length,
                              itemBuilder: (matchChatContext, matchIndex) {
                                FirebaseAuth auth = FirebaseAuth.instance;
                                User? user = auth.currentUser;

                                var receiverId = user!.uid;
                                var matchData = matchSnapshot.data[matchIndex];

                                return StreamBuilder(
                                    stream: streamMessagePreview(
                                        user.uid,
                                        matchData['user_id'],
                                        matchData['first_name']),
                                    builder: (previewContext, previewSnapshot) {
                                      return Message(
                                          senderId: matchData['user_id'],
                                          receiverId: receiverId,
                                          msgPreview:
                                              previewSnapshot.data.toString(),
                                          senderName: matchData['first_name']);
                                    });
                              })),
                    ],
                  );
                }
              }
              return const CircularProgressIndicator(color: Colors.green);
            }));
  }
}

class Message extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String senderName;
  final String msgPreview;

  const Message(
      {super.key,
      required this.senderId,
      required this.receiverId,
      required this.senderName,
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
              builder: (context) => ChatContent(
                    receiverId: receiverId,
                    senderData: {
                      'senderId': senderId,
                      'senderName': senderName
                    },
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
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/dating-appp-2d438.appspot.com/o/user_images%2F${senderId}.jpg?alt=media&token=d69fa31c-5470-4e27-8081-eeb7fc49a17a'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    color: const Color(0xff33D15F),
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
                      child: Text(senderName,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(msgPreview,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          )),
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
