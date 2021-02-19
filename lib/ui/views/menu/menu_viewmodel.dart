import 'package:assistant_compta_medge/ui/views/consultations/consultations_view.dart';
import 'package:assistant_compta_medge/ui/views/home/home_view.dart';
import 'package:assistant_compta_medge/ui/views/profile/profile_view/profil_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';

final menuViewModelProvider = ChangeNotifierProvider<MenuViewModel>((ref) {
  return MenuViewModel();
});

class MenuViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  get currentIndex => _currentIndex;

  /// Indicates whether we're going forward or backward in terms of the index we're changing.
  /// This is very helpful for the page transition directions.

  setIndex(int index) {
    _currentIndex = index;
    print('index is $index');
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

  Widget getViewForIndex(int index) {
    switch (index) {
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
}
