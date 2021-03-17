import 'dart:io';
import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/dialog_service.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addWorkPlaceViewModelProvider = ChangeNotifierProvider<AddWorkPlaceViewModel>((ref) {
  return AddWorkPlaceViewModel(
    ref.watch(firestoreProvider),
    ref.watch(dialogServiceProvider),
    ref.watch(navigationServiceProvider),
  );
});

class AddWorkPlaceViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final DialogService _dialogService;
  final NavigationService _navigationService;

  AddWorkPlaceViewModel(
    this._firestoreService,
    this._dialogService,
    this._navigationService,
  );

  /// =========================================================================
  /// =========================== Workplace CRUD ==============================
  /// =========================================================================

  /// Check if :
  /// empty string ? error
  /// name is already taken ? error
  /// Else ? success
  Future<void> addWorkPlace({String name}) async {
    // Champs 'nom' bien rempli ? show error : requete firestore
    if (name == "") {
      await _dialogService.showDialog(
        title: 'Erreur',
        description: 'Veuillez entrer un nom pour le Cabinet',
        dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material,
        barrierDismissible: true,
      );
    } else {
      Workplace workplace = await _firestoreService.getWorkplace(name: name);
      if (workplace != null) {
        if (workplace.name == name) {
          await _dialogService.showDialog(
            title: 'Erreur',
            description:
                'Le nom que vous avez choisis existe déjà dans votre liste de lieu(x) de travail.',
            dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material,
            barrierDismissible: true,
          );
        }
      } else {
        await _firestoreService.addWorkplace(workplace: Workplace(name: name, isDefault: false));
        notifyListeners();
        await _dialogService.showDialog(
          title: 'OK !',
          description: 'Le cabinet $name a correctement été ajouté à vos lieux de travail.',
          dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material,
          barrierDismissible: true,
        );
      }
    }
  }

  Future<void> deleteWorkplace({String name}) async {
    var res = await _dialogService.showConfirmationDialog(
      title: 'Alerte',
      description: 'Êtes-vous sûr de vouloir supprimé le cabinet $name ?',
      cancelTitle: 'Non',
      confirmationTitle: 'Oui',
    );
    if (res.confirmed) {
      await _firestoreService.deleteWorkplace(name: name);
      notifyListeners();
      await _dialogService.showDialog(
        title: 'Ok !',
        description: 'Le Cabinet $name a bien été supprimé.',
        barrierDismissible: true,
      );
    }
  }

  /// =========================================================================
  /// =========================== Navigation CRUD =============================
  /// =========================================================================
  Future<void> navigateToMenu() async {
    await _navigationService.clearStackAndShow(Routes.menuView);
  }
}
