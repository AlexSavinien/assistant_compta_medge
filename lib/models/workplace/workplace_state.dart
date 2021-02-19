import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:flutter_riverpod/all.dart';

final workplaceNotifierProvider =
    StateNotifierProvider<WorkplaceNotifier>((ref) {
  return WorkplaceNotifier(
    ref.watch(medecinNotifierProvider.state),
  );
});

// ignore: camel_case_types
class WorkplaceNotifier extends StateNotifier<Workplace> {
  WorkplaceNotifier(
    this._medecin,
  ) : super(_medecin.selectedWorkplace);
  final Medecin _medecin;

  String get id => state.id;
  void setId({String newId}) {
    state.id = newId;
  }

  String get name => state.name;
  void setName({String newName}) {
    state.name = newName;
  }

  Medecin get medecin => state.medecin;
  void setMedecin({Medecin newMedecin}) {
    state.medecin = newMedecin;
  }
}
