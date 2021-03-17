import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final startUpViewModelProvider = Provider<StartUpViewModel>((ref) {
  return StartUpViewModel(
    ref.watch(authentificationServiceProvider),
  );
});

class StartUpViewModel {
  final AuthentificationService _auth;

  StartUpViewModel(
    this._auth,
  );

  Stream<User> get onAuthChanged => _auth.onAuthStateChanged;
}
