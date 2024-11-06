import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';

final List<String> cities = [
  'New York',
  'London',
  'Tokyo',
  'Paris',
  'Sydney',
  'Berlin',
  'Dubai',
  'Singapore',
  'Los Angeles',
  'Toronto',
  'Hong Kong',
  'Beijing',
  'San Francisco',
  'Mumbai',
  'Mexico City',
  'Moscow',
  'São Paulo',
  'Istanbul',
  'Seoul',
  'Bangkok'
];

List<String> genderIdentities = [
  'Woman (she/her)',
  'Man (he/him)',
  'Non binary (they/them)',
  'Agender (they/them)',
  'Gender non-conforming (they/them)',
  'Prefer not to say',
];

List<String> occupations = [
  'Advertising and marketing',
  'Aerospace',
  'Agriculture',
  'Computer and technology',
  'Construction',
  'Education',
  'Energy',
  'Entertainment',
  'Fashion',
  'Finance',
  'Healthcare',
  'Hospitality',
  'Manufacturing',
  'Service',
  'Media and news',
  'Telecommunications',
];

int calculateAge(int birthdateInt) {
  // Extract year, month, and day from the birthdate integer
  int year = birthdateInt ~/ 10000;
  int month = (birthdateInt % 10000) ~/ 100;
  int day = birthdateInt % 100;

  // Create a DateTime object for the birthdate
  DateTime birthDateTime = DateTime(year, month, day);

  // Get today's date
  DateTime today = DateTime.now();

  // Calculate the age
  int age = today.year - birthDateTime.year;

  // Check if the current date is before the birthdate in the current year
  if (today.month < birthDateTime.month ||
      (today.month == birthDateTime.month && today.day < birthDateTime.day)) {
    age--; // Subtract one from the age if the birthday hasn't occurred yet this year
  }

  return age;
}

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

DateTime parseDateFromInt(int yyyymmdd) {
  int year = yyyymmdd ~/ 10000;
  int month = (yyyymmdd % 10000) ~/ 100;
  int day = yyyymmdd % 100;
  return DateTime(year, month, day);
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

Future<String> getCityFromCoordinates(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      String city = placemarks[0].locality ?? 'Unknown City';
      return city;
    }
  } catch (e) {
    print('Error fetching city name: $e');
    return Future.delayed(const Duration(seconds: 2), () => 'Unknown City');
  }
  return Future.delayed(const Duration(seconds: 2), () => 'Unknown City');
}

Future<void> writeData(
  String collection,
  String fieldToFilter,
  String valueToFilter,
  String columnToWrite,
  dynamic valueToWrite,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection(collection)
        .where(fieldToFilter, isEqualTo: valueToFilter)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If the document with the specified field and value exists, update the column
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      await documentSnapshot.reference.update({columnToWrite: valueToWrite});
    }
  } catch (e) {}
}

Future getSelectedInterests(uid) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('selected_interests')
        .where('user_id', isEqualTo: uid)
        .get();

    return querySnapshot;
  } catch (e) {
    print(e);
    return [];
  }
}

Future getInterestNameFromId(interestId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('interests')
        .where('interest_id', isEqualTo: interestId)
        .get();

    return querySnapshot;
  } catch (e) {
    print(e);
    return [];
  }
}
