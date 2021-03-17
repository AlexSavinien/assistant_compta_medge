import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/services/navigation_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signUpViewModelProvider = StateNotifierProvider<SignUpViewModel>((ref) {
  return SignUpViewModel(
    ref.watch(authentificationServiceProvider),
    ref.watch(navigationServiceProvider),
    ref.watch(firestoreProvider),
  );
});

class SignUpViewModel extends StateNotifier {
  SignUpViewModel(
    this._auth,
    this._navigationService,
    this._firestoreService,
  ) : super(_auth);

  final AuthentificationService _auth;
  final NavigationService _navigationService;
  final FirestoreService _firestoreService;

  Future<void> signUp({String email, String password}) async {
    Medecin medecin = Medecin(email: email, preferences: {
      'defaultPrice': 25,
      'defaultPaiementType': 'cb',
      'defaultWorkplace': 'none',
    });
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestoreService.addMedecin(medecin: medecin);
    await navigateToAddWorkplace();
  }

  Future navigateToSignIn() async {
    await _navigationService.clearStackAndShow(Routes.signInView);
  }

  Future navigateToAddWorkplace() async {
    _navigationService.clearStackAndShow(Routes.addWorkPlaceView);
  }
}
