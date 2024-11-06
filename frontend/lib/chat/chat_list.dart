import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'chat_content.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:catalyst/utils/utils.dart';

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

Stream<List<dynamic>> fetchMatches(String currentUserLocation) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final currentUserId = user?.uid;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  return usersCollection.snapshots().asyncMap((snapshot) async {
    var users =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    var potentialMatches = users.where((user) {
      return user['location'] == currentUserLocation;
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
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  bool throbber = false;
  String noMessagesErrorMsg = '';
  late String matchId;
  double latitude = 0.0;
  double longitude = 0.0;

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

  dynamic streamMessagePreview(
      String receiverId, String senderId, String matchName) {
    Stream<QuerySnapshot<Map<String, dynamic>>> receivedQuerySnapshot =
        FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: senderId)
            .where('receiver_id', isEqualTo: receiverId)
            .snapshots();

    Stream<QuerySnapshot<Map<String, dynamic>>> sentQuerySnapshot =
        FirebaseFirestore.instance
            .collection('messages')
            .where('sender_id', isEqualTo: receiverId)
            .where('receiver_id', isEqualTo: senderId)
            .snapshots();

    Stream<List<dynamic>> messageStream =
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
      return snapshots.isEmpty
          ? [
              {'content': 'Start your conversation!'}
            ]
          : allDocuments;
    });
    return messageStream;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String currentUserId = auth.currentUser!.uid;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: const Text(
              'Inbox',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            )),
        body: FutureBuilder(
          future: getUserData(currentUserId),
          builder: (BuildContext userContext, AsyncSnapshot userSnapshot) {
            if (userSnapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userSnapshot.data['location'] != null) {
              return StreamBuilder(
                  stream: fetchMatches(userSnapshot.data['location']),
                  builder:
                      (BuildContext matchContext, AsyncSnapshot matchSnapshot) {
                    if (matchSnapshot.hasError) {
                      return const Center(
                          child: CircularProgressIndicator(color: Colors.red));
                    } else {
                      if (matchSnapshot.connectionState ==
                          ConnectionState.active) {
                        return Column(
                          children: [
                            Flexible(
                                flex: 12,
                                child: ListView.builder(
                                    itemCount: matchSnapshot.data.length,
                                    itemBuilder:
                                        (matchChatContext, matchIndex) {
                                      if (matchSnapshot.data.length == 0) {
                                        return const Column(
                                          children: [
                                            Text(
                                                'No matches yet - keep swiping!'),
                                          ],
                                        );
                                      }

                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      User? user = auth.currentUser;

                                      var receiverId = user!.uid;
                                      var matchData =
                                          matchSnapshot.data[matchIndex];

                                      return StreamBuilder(
                                          stream: streamMessagePreview(
                                              user.uid,
                                              matchData['user_id'],
                                              matchData['first_name']),
                                          builder: (previewContext,
                                              previewSnapshot) {
                                            String content =
                                                'Start your conversation with ${matchData['first_name']}!';

                                            if (previewSnapshot.data is List &&
                                                (previewSnapshot.data as List)
                                                    .isNotEmpty) {
                                              var lastDocument =
                                                  (previewSnapshot.data as List)
                                                      .last;
                                              if (lastDocument['content'] !=
                                                  null) {
                                                content =
                                                    lastDocument['content'];
                                              }
                                            }

                                            return Message(
                                                senderId: matchData['user_id'],
                                                receiverId: receiverId,
                                                msgPreview: content,
                                                senderName:
                                                    matchData['first_name']);
                                          });
                                    })),
                          ],
                        );
                      }
                    }
                    return const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: Colors.green,
                              strokeWidth: 10,
                            )));
                  });
            } else {
              return Center(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No matches yet - keep swiping!'),
                  ],
                ),
              );
            }
          },
        ));
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
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     Color.fromARGB(50, 114, 1, 228),
            //     Color.fromARGB(35, 114, 1, 228),
            //     Color.fromARGB(11, 114, 1, 228),
            //   ],
            // ),
            border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
        )),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              FutureBuilder(
                  future: findValidFirebaseUrl(senderId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return CircularProgressIndicator();
                    }
                    var imageFile = NetworkImage(snapshot.data.toString());

                    return Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: imageFile,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    );
                  }),
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
