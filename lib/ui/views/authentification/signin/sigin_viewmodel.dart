import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/services/navigation_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signInViewModelProvider = StateNotifierProvider<SignInViewModel>((ref) {
  return SignInViewModel(
    ref.watch(authentificationServiceProvider),
    ref.watch(navigationServiceProvider),
  );
});

class SignInViewModel extends StateNotifier {
  SignInViewModel(
    this._auth,
    this._navigationService,
  ) : super(_auth);

  final AuthentificationService _auth;
  final NavigationService _navigationService;

  Future signIn({String email, String password}) async {
    String res = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (res == 'success') {
      await navigateToMenu();
    }
  }

  Future navigateToSignUp() async {
    await _navigationService.clearStackAndShow(Routes.signUpView);
  }

  Future navigateToMenu() async {
    await _navigationService.clearStackAndShow(Routes.menuView);
  }
}
