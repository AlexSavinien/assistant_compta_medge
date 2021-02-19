import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';

final startUpViewModelProvider = Provider<StartUpViewModel>((ref) {
  return StartUpViewModel(
    ref.watch(authentificationServiceProvider),
    ref.watch(medecinNotifierProvider),
  );
});

class StartUpViewModel {
  final AuthentificationService _auth;
  final MedecinStateNotifier _medecinStateNotifier;

  StartUpViewModel(this._auth, this._medecinStateNotifier);

  Stream<User> get onAuthChanged => _auth.onAuthStateChanged;

  Future<void> updateMedecinInfo() async {
    await _medecinStateNotifier.getMedecinInfoFromFirebase();
  }
}
