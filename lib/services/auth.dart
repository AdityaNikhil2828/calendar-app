import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> currentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      throw e;
    }
  }
}
