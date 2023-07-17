import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with token that is generated from the backend
  Future<UserCredential> signInWithToken(String token) async {
    return await _firebaseAuth.signInWithCustomToken(token);
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
