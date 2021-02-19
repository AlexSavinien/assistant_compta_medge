import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/services/navigation_service.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:stacked_services/stacked_services.dart';

final signUpViewModelProvider = StateNotifierProvider<SignUpViewModel>((ref) {
  return SignUpViewModel(
      ref.watch(authentificationServiceProvider),
      ref.watch(navigationServiceProvider),
      ref.watch(firestoreProvider),
      ref.watch(medecinNotifierProvider));
});

class SignUpViewModel extends StateNotifier {
  SignUpViewModel(this._auth, this._navigationService, this._firestoreService,
      this._medecinStateNotifier)
      : super(_auth);

  final AuthentificationService _auth;
  final NavigationService _navigationService;
  final FirestoreService _firestoreService;
  final MedecinStateNotifier _medecinStateNotifier;

  Future<void> updateMedecinInfo() async {
    await _medecinStateNotifier.getMedecinInfoFromFirebase();
  }

  Future<void> signUp({String email, String password}) async {
    Medecin medecin = Medecin(email: email);
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestoreService.addMedecin(medecin: medecin);
    await updateMedecinInfo();
  }

  Future navigateToSignIn() async {
    await _navigationService.navigateTo(Routes.signInView);
  }

  Future navigateToAddWorkplace() async {
    await _navigationService.navigateTo(Routes.addWorkPlaceView);
  }
}
