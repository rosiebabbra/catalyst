import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

bool isSafeFromSqlInjection(String input) {
  RegExp sqlPattern = RegExp(
    r"(\b(union|select|insert|update|delete|drop|alter)\b)|(--\s|/\*|\*/)",
    caseSensitive: false,
  );
  return !sqlPattern.hasMatch(input);
}

Future<String?> findValidFirebaseUrl(String senderId) async {
  var token = dotenv.get('FIREBASE_TOKEN');
  var fileExts = ['.jpeg', '.jpg', '.png'];
  var baseUrl =
      'https://firebasestorage.googleapis.com/v0/b/dating-appp-2d438.appspot.com/o/';
  var imgBucket = 'user_images%2F';
  var url = '';

  for (var ext in fileExts) {
    url = '${baseUrl}${imgBucket}${senderId}${ext}?alt=media&token=$token';
    var response = await http.head(Uri.parse(url));

    if (response.statusCode == 200) {
      return url;
    }
  }
  return '${baseUrl}error_loading_image.png?alt=media&token=$token';
}

double calculateDistance(GeoPoint point1, GeoPoint point2) {
  const earthRadiusMiles = 3958.8; // Radius of the Earth in miles

  double radians(double degrees) {
    return degrees * (pi / 180);
  }

  num haversine(double a, double b) {
    return pow(sin((b - a) / 2), 2);
  }

  double haversineDistance() {
    double lat1Rad = radians(point1.latitude);
    double lon1Rad = radians(point1.longitude);
    double lat2Rad = radians(point2.latitude);
    double lon2Rad = radians(point2.longitude);

    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    double a = haversine(dLat, dLat) +
        cos(lat1Rad) * cos(lat2Rad) * haversine(dLon, dLon);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMiles * c;
  }

  return haversineDistance();
}

Future<dynamic> getUserData(String userId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('user_id', isEqualTo: userId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      var recordData = document.data() as Map<String, dynamic>;
      return recordData;
    }
  } else {
    return {'first_name': 'Error rendering user name'};
  }
}

updateUserFirstName(User? currentUser, String firstName) async {
  if (isSafeFromSqlInjection(firstName)) {
    // Filter to user's record and write name
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: currentUser?.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Assume there's only one matching document (you might need to adjust if multiple documents match)
      DocumentSnapshot documentSnapshot = snapshot.docs.first;

      // Get the document reference and update the fields
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.id);

      // Update the fields
      await documentReference.update({
        'first_name': firstName,
      });
    }
  }
}

updateUserBirthdate(User? user, int birthDate) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('user_id', isEqualTo: user?.uid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Assume there's only one matching document (you might need to adjust if multiple documents match)
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    // Get the document reference and update the fields
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(documentSnapshot.id);

    // Update the fields
    await documentReference.update({
      'birthdate': birthDate,
    });
  }
}
