import 'dart:ffi';

import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/services/navigation_service.dart';
import 'package:assistant_compta_medge/services/shared_preference_service.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/add_worplace/add_workplace_view.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

final profilViewModelProvider = ChangeNotifierProvider.autoDispose<ProfilViewModel>((ref) {
  FirestoreService _firestoreService = ref.watch(firestoreProvider);
  NavigationService _navigationService = ref.watch(navigationServiceProvider);
  SharedPreferences _sharedPreferences = ref.watch(sharedPreferencesProvider);
  Medecin _medecin = ref.watch(medecinProvider)?.data?.value;

  double defaultPrice = _sharedPreferences.getDouble('defaultPrice');
  List<String> defaultPaiementType = _sharedPreferences.getStringList('defaultPaiementType');
  List<String> defaultWorkplace = _sharedPreferences.getStringList('defaultWorkplace');

  return ProfilViewModel(
    _firestoreService,
    _navigationService,
    _sharedPreferences,
    _medecin,
  );
});

class ProfilViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final NavigationService _navigationService;
  final SharedPreferences _sharedPreferences;
  final Medecin _medecin;

  ProfilViewModel(
    this._firestoreService,
    this._navigationService,
    this._sharedPreferences,
    this._medecin,
  );

  // double _defaultPrice;
  // double get defaultPrice => _defaultPrice;
  // Future<void> setDefaultPrice({double newDefaultPrice}) async {
  //   _defaultPrice = newDefaultPrice;
  //   await _sharedPreferences.setDouble('defaultPrice', newDefaultPrice);
  //   print('New default price is : ${defaultPrice.toString()}');
  // }
  //
  // Workplace _workplace;
  // Workplace _defaultWorkplace;
  // Workplace get defaultWorkplace => _defaultWorkplace;
  // Future<void> setDefaultWorplace({Workplace newDefaultWorkplace}) async {
  //   _defaultWorkplace = newDefaultWorkplace;
  //   await _sharedPreferences
  //       .setStringList('defaultWorkplace', [newDefaultWorkplace.name, newDefaultWorkplace.id]);
  //   print('New default workplace is : ${defaultWorkplace.name.toString()}');
  // }
  //
  // Map<String, dynamic> _defaultPaiementType;
  // Map<String, dynamic> get defaultPaiementType => _defaultPaiementType;
  // Future<void> setDefaultPaiementType({Map<String, dynamic> newDefaultPaiementType}) async {
  //   _defaultPaiementType = newDefaultPaiementType;
  //   await _sharedPreferences.setStringList(
  //       'defaultPaiementType', [newDefaultPaiementType['value'], newDefaultPaiementType['title']]);
  //   print('New default paiement type : ${defaultPaiementType.toString()}');
  //   print(
  //       'Sharedpreference PaiementType : ${_sharedPreferences.getStringList('defaultPaiementType').toString()}');
  // }

  void getMedecin() {
    print(_medecin.preferences.toString());
  }

  Future<void> updatePreferences({String fieldName, dynamic newValue}) async {
    await _firestoreService.updateMedecinPreferences(fieldName: fieldName, newValue: newValue);
  }

  Future<void> updateWorkplaceToDefault({Workplace workplace}) async {
    await _firestoreService.updatePreviousDefaultWorkplace();
    workplace.isDefault = true;
    await _firestoreService.updateWorkplace(workplace: workplace);
  }

  Future<void> updateFirstname({String newFirstname}) async {
    await _firestoreService.updateMedecin(fieldName: 'firstname', newValue: newFirstname);
  }

  Future<void> updateLastname({String newLastname}) async {
    await _firestoreService.updateMedecin(fieldName: 'lastname', newValue: newLastname);
  }

  Future<void> updateEmail({String newEmail}) async {
    await _firestoreService.updateMedecin(fieldName: 'email', newValue: newEmail);
  }

  void navigateToAddWorkplace() {
    _navigationService.navigateWithTransition(AddWorkPlaceView(),
        transition: NavigationTransition.DownToUp);
  }
}
