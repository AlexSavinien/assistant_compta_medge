// import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/services/navigation_service.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:stacked_services/stacked_services.dart';

final signInViewModelProvider = StateNotifierProvider<SignInViewModel>((ref) {
  return SignInViewModel(ref.watch(authentificationServiceProvider),
      ref.watch(navigationServiceProvider), ref.watch(medecinNotifierProvider));
});

class SignInViewModel extends StateNotifier {
  SignInViewModel(
      this._auth, this._navigationService, this._medecinStateNotifier)
      : super(_auth);

  final AuthentificationService _auth;
  final NavigationService _navigationService;
  final MedecinStateNotifier _medecinStateNotifier;

  Future<void> updateMedecinInfo() async {
    await _medecinStateNotifier.getMedecinInfoFromFirebase();
  }

  Future signIn({String email, String password}) async {
    String res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (res == 'success') {
      await updateMedecinInfo();
    }
  }

  Future navigateToSignUp() async {
    await _navigationService.navigateTo(Routes.signUpView);
  }
}
