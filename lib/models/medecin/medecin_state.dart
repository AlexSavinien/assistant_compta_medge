import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:flutter_riverpod/all.dart';

final medecinNotifierProvider =
    StateNotifierProvider<MedecinStateNotifier>((ref) {
  return MedecinStateNotifier(ref.read(
    firestoreProvider,
  ));
});

class MedecinStateNotifier extends StateNotifier<Medecin> {
  MedecinStateNotifier(this._firestoreService) : super(Medecin());
  final FirestoreService _firestoreService;

  Future<void> getMedecinInfoFromFirebase() async {
    print('Trying to get med info from firebase');
    state = await _firestoreService.getMedecin();
  }

  String get id => state.id;
  void setId({String newId}) {
    state.id = newId;
  }

  String get firstname => state.firstname;
  void setFirstname({String newFirstname}) {
    state.firstname = newFirstname;
  }

  String get lastname => state.lastname;
  void setLastName({String newLastName}) {
    state.lastname = newLastName;
  }

  String get email => state.email;
  void setEmail({String newEmail}) {
    state.email = newEmail;
  }

  List<Workplace> get workplaces => state.workplaces;
  void setWorkplaces(List<Workplace> workplaces) {
    state.workplaces = workplaces;
  }

  Workplace get selectedWorkplace => state.selectedWorkplace;
  void setSelectedWorkplace({Workplace workplace}) {
    state.selectedWorkplace = workplace;
  }
}
