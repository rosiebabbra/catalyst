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
      if (await determineMatch(
          'a3IXF0jBT0SkVW53hCIksmfsqAh2', user['user_id'])) {
        matchedUsers.add(user);
      }
    }

    // Drop the current User ID from here
    matchedUsers.removeWhere(
        (user) => user['user_id'] == 'a3IXF0jBT0SkVW53hCIksmfsqAh2');

    return matchedUsers;
  });
}

class ChatList extends StatefulWidget {
  final List<String> userIds; // Declare the required argument

  const ChatList({Key? key, required this.userIds}) : super(key: key);

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
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075),
                    const Flexible(
                      child: Center(
                          child: Text(
                        'Inbox',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      )),
                    ),
                    Flexible(
                        flex: 10,
                        child: ListView.builder(
                            itemCount: matchSnapshot.data.length,
                            itemBuilder: (matchChatContext, matchIndex) {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              User? user = auth.currentUser;

                              var receiverId = user!.uid;
                              var matchData = matchSnapshot.data[matchIndex];
                              var matchId = matchData['user_id'];

                              return FutureBuilder(
                                  future: getMessagePreview(user.uid, matchId),
                                  builder: (previewContext, previewSnapshot) {
                                    return Message(
                                        senderId: matchId,
                                        receiverId: receiverId,
                                        msgPreview: (previewSnapshot.data ==
                                                null)
                                            ? 'Start your chat with ${matchData['first_name']}!'
                                            : previewSnapshot.data.toString(),
                                        senderName: matchData['first_name']);
                                  });
                            })),
                  ],
                );
              }
            }
            return CircularProgressIndicator(color: Colors.green);
            // return Scaffold(
            //     body: Column(
            //   children: [
            //     const SizedBox(
            //       height: 75,
            //     ),
            //     const Center(
            //         child: Text(
            //       'Inbox',
            //       style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            //     )),
            //     if (throbber)
            //       const CircularProgressIndicator(color: Color(0xff33D15F)),
            //     if (noMessagesErrorMsg.isNotEmpty)
            //       Padding(
            //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            //         child: Text(noMessagesErrorMsg.toString(),
            //             style: const TextStyle(fontSize: 18)),
            //       ),
            //     Flexible(
            //       child: StreamBuilder(
            //           stream: userSnapshots,
            //           builder: (BuildContext context,
            //               AsyncSnapshot<QuerySnapshot> snapshot) {
            //             print('these are the users that we have messages from');
            //             print(widget.userIds);
            //             if (snapshot.connectionState == ConnectionState.waiting) {
            //               // While waiting for data, show a loading indicator
            //               return const CircularProgressIndicator(
            //                   color: Color(0xff33D15F));
            //             } else if (snapshot.hasError) {
            //               // If an error occurs, display an error message
            //               return Text('Error: ${snapshot.error}');
            //             } else if (!snapshot.hasData) {
            //               // If there's no data, show a message indicating an empty state
            //               return const Text('No data available.');
            //             }

            //             var inboxList = snapshot.data!.docs.toList();
            //             return ListView(
            //                 children: inboxList.map((DocumentSnapshot document) {
            //               FirebaseAuth auth = FirebaseAuth.instance;
            //               User? user = auth.currentUser;

            //               var senderIds = getAllSenderIds(user!.uid);

            //               return FutureBuilder<Object>(
            //                   future: senderIds,
            //                   builder: (BuildContext context,
            //                       AsyncSnapshot senderIdSnapshot) {
            //                     if (senderIdSnapshot.connectionState ==
            //                         ConnectionState.waiting) {
            //                       throbber = true;
            //                     }
            //                     if (senderIdSnapshot.hasError) {
            //                       return Text('Error: ${senderIdSnapshot.error}');
            //                     }
            //                     if (senderIdSnapshot.data == null) {
            //                       noMessagesErrorMsg =
            //                           'You have no messages yet!';
            //                     }
            //                     throbber = false;
            //                     noMessagesErrorMsg = '';

            //                     return SizedBox(
            //                       height:
            //                           MediaQuery.of(context).size.height * 0.75,
            //                       child: (senderIdSnapshot.data != null)
            //                           ? ListView.builder(
            //                               itemCount:
            //                                   (senderIdSnapshot.data != null)
            //                                       ? senderIdSnapshot.data.length
            //                                       : 1,
            //                               itemBuilder:
            //                                   (BuildContext context, index) {
            //                                 FirebaseAuth auth =
            //                                     FirebaseAuth.instance;
            //                                 User? user = auth.currentUser;

            //                                 var messagePreview =
            //                                     getMessagePreview(user!.uid,
            //                                         senderIdSnapshot.data[index]);
            //                                 return FutureBuilder(
            //                                   future: messagePreview,
            //                                   builder: (BuildContext context,
            //                                       AsyncSnapshot
            //                                           msgPreviewSnapshot) {
            //                                     if (msgPreviewSnapshot
            //                                             .connectionState ==
            //                                         ConnectionState.waiting) {
            //                                       return const CircularProgressIndicator(
            //                                           color: Color(0xff33D15F));
            //                                     }
            //                                     if (msgPreviewSnapshot.hasError) {
            //                                       return Text(
            //                                           'Error: ${msgPreviewSnapshot.error}');
            //                                     }
            //                                     if (!msgPreviewSnapshot.hasData) {
            //                                       return const Text(
            //                                           'No sender IDs available.');
            //                                     }

            //                                     return FutureBuilder(
            //                                       future: getUserName(
            //                                           senderIdSnapshot
            //                                               .data[index]),
            //                                       builder: (BuildContext context,
            //                                           nameSnapshot) {
            //                                         if (nameSnapshot
            //                                                 .connectionState ==
            //                                             ConnectionState.waiting) {
            //                                           return const SizedBox(
            //                                             height: 25,
            //                                             width: 25,
            //                                             child:
            //                                                 CircularProgressIndicator(
            //                                                     color: Color(
            //                                                         0xff33D15F)),
            //                                           );
            //                                         }
            //                                         if (nameSnapshot.hasError) {
            //                                           return Text(
            //                                               'Error: ${nameSnapshot.error}');
            //                                         }
            //                                         if (!nameSnapshot.hasData) {
            //                                           return const Text(
            //                                               'No sender IDs available.');
            //                                         }
            //                                         return Message(
            //                                             msgPreview:
            //                                                 msgPreviewSnapshot
            //                                                     .data,
            //                                             name: nameSnapshot.data
            //                                                 .toString());
            //                                       },
            //                                     );
            //                                   },
            //                                 );
            //                               },
            //                             )
            //                           : const Text(''),
            //                     );
            //                   });
            //             }).toList());
            //           }),
            //     ),
            //   ],
            // ));
          }),
    );
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
                      child: Text(senderName,
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
