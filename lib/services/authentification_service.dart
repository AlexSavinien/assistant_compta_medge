import 'package:assistant_compta_medge/services/dialog_service.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/services/shared_preference_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

final authentificationServiceProvider = Provider<AuthentificationService>((ref) {
  final DialogService _dialogService = ref.watch(dialogServiceProvider);
  return AuthentificationService(_dialogService);
});

final authStateChangesProvider =
    StreamProvider<User>((ref) => ref.watch(authentificationServiceProvider).onAuthStateChanged);

class AuthentificationService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final DialogService _dialogService;
  AuthentificationService(this._dialogService);

  Stream<User> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  User get currentUser => _auth.currentUser;

  Future<bool> createUserWithEmailAndPassword({String email, String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print('User have sign up with : email : $email');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        await _dialogService.showDialog(
          title: 'Alerte',
          description: 'Le mot de passe choisi est trop faible',
          cancelTitle: 'OK',
          barrierDismissible: true,
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        await _dialogService.showDialog(
          title: 'Alerte',
          description: 'Un compte existe déjà pour cette adresse mail.',
          cancelTitle: 'OK',
          barrierDismissible: true,
        );
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> signInWithEmailAndPassword({String email, String password}) async {
    String returnMessage;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User have signed out');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
