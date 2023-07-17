import 'package:cloud_firestore/cloud_firestore.dart';

import '/repositories/repositories.dart';
import '/models/models.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  @override
  Stream<List<User>> getUsers(String userId) {
    return _firebaseFirestore.collection('users').snapshots().map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.userId)
        .set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) async {
    return _firebaseFirestore
        .collection('users')
        .doc(user.userId)
        .update(user.toMap())
        .then(
          (value) => print('User document updated.'),
        );
  }

  @override
  Future<void> updateUserPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return _firebaseFirestore.collection('users').doc(user.userId).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }
}
