import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<User> getCurrentUser();
  Future<void> signOut();
  Future<void> deleteUser();
  Future<void> resetPasswordEmail();
  Stream<User> streamUserValue();
}

class AuthService implements AuthImplementation {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential userCredentials =
        (await _auth.signInWithEmailAndPassword(email: email, password: password));

    return userCredentials.user.uid;
  }

  Stream<User> streamUserValue() {
    return _auth.authStateChanges();
  }

  Future<String> signUp(String email, String password) async {
    UserCredential userCredentials =
        (await _auth.createUserWithEmailAndPassword(email: email, password: password));

    return userCredentials.user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = _auth.currentUser;

    if (user != null) {
      return user;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUser() async {
    User user = _auth.currentUser;
    user.delete();
  }

  Future<void> resetPasswordEmail() async {
    // await _auth.currentUser.updateEmail('dukesmn10@gmail.com');
    await _auth.sendPasswordResetEmail(email: _auth.currentUser.email);
  }

  Future<void> resetPasswordEmailWithoutAuth(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
