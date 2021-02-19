import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/consultation/consultation_state.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel(
    ref.watch(firestoreProvider),
    ref.watch(consultationNotifierProvider.state),
  );
});

class HomeViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final Consultation _consultationState;

  HomeViewModel(
    this._firestoreService,
    this._consultationState,
  );

  Future<void> addConsult() async {
    Consultation consultation = _consultationState;
    print('Consultation avant envois Firebase : ${consultation.toString()}');
    await _firestoreService.addConsultation(consultation: consultation);
  }
}
