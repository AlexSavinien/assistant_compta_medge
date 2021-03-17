import 'dart:io';
import 'dart:math';

import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/services/dialog_service.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/ui/views/menu/consultations/consultations_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/home/home_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/profile_view/profil_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

final menuViewModelProvider = ChangeNotifierProvider<MenuViewModel>((ref) {
  return MenuViewModel(
    ref.watch(dialogServiceProvider),
    ref.watch(authentificationServiceProvider),
  );
});

class MenuViewModel extends ChangeNotifier {
  final DialogService _dialogService;
  final AuthentificationService _auth;

  int _currentIndex = 0;

  MenuViewModel(this._dialogService, this._auth);
  get currentIndex => _currentIndex;

  setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<BottomNavigationBarItem> navigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Accueil',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_rounded),
      label: 'Consultations',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_rounded),
      label: 'Profile',
    ),
  ];

  Widget getViewForIndex() {
    switch (currentIndex) {
      case 0:
        return HomeView();
      case 1:
        return ConsultationsView();
      case 2:
        return ProfileView();
      default:
        return HomeView();
    }
  }

  Widget getTitleViewForIndex() {
    switch (currentIndex) {
      case 0:
        return AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ajouter une consultation'),
              GestureDetector(
                child: Icon(Icons.help_outline_rounded),
                onTap: () {
                  help(helpDescription: 'Aide ajout consultation');
                },
              ),
            ],
          ),
        );
      case 1:
        return AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vos consultations'),
              GestureDetector(
                child: Icon(Icons.help_outline_rounded),
                onTap: () {
                  help(helpDescription: 'Aide consultation');
                },
              ),
            ],
          ),
        );
      case 2:
        return AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profil'),
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.help_outline_rounded),
                    onTap: () {
                      help(helpDescription: 'Aide profil');
                    },
                  ),
                  SizedBox(width: 20),
                  GestureDetector(child: Icon(Icons.logout), onTap: signOut),
                ],
              ),
            ],
          ),
        );
      default:
        return HomeView();
    }
  }

  Future signOut() async {
    var res = await _dialogService.showConfirmationDialog(
      title: 'Déconnexion',
      description: 'Voulez-vous vraiment vous déconnecter ?',
      confirmationTitle: 'Oui',
      cancelTitle: 'Non',
      dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material,
    );
    if (res.confirmed) {
      await _auth.signOut();
    }
  }

  Future<void> help({String helpDescription}) async {
    await _dialogService.showDialog(
      title: 'Aide',
      description: helpDescription,
      barrierDismissible: true,
      dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material,
    );
  }
}
