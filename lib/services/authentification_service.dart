import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';

final authentificationServiceProvider =
    Provider<AuthentificationService>((ref) {
  return AuthentificationService();
});

final authStateChangesProvider = StreamProvider<User>(
    (ref) => ref.watch(authentificationServiceProvider).onAuthStateChanged);

class AuthentificationService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged => _auth.authStateChanges();

  User get currentUser => _auth.currentUser;

  Future<bool> createUserWithEmailAndPassword(
      {String email, String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('User have sign up with : email : $email');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    String returnMessage;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('User have sign in with : email : $email');
      returnMessage = 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        returnMessage = 'error';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        returnMessage = 'error';
      }
    }
    return returnMessage;
  }
}
