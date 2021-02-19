import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:flutter_riverpod/all.dart';

final consultationNotifierProvider =
    StateNotifierProvider<ConsultationStateNotifier>((ref) {
  return ConsultationStateNotifier(
    ref.watch(medecinNotifierProvider),
  );
});

// ignore: camel_case_types
class ConsultationStateNotifier extends StateNotifier<Consultation> {
  ConsultationStateNotifier(this._medecinStateNotifier)
      : super(
          Consultation(
            tp: false,
            price: 25,
            workplace: _medecinStateNotifier.state.selectedWorkplace ?? null,
            note: '',
          ),
        );
  MedecinStateNotifier _medecinStateNotifier;

  String get id => state.id;
  void setId({String id}) {
    state.id = id;
    print('New id is now : ${state.id}');
  }

  String get paiementType => state.paiementType;
  void setPaiementType({String newPaiementType}) {
    state.paiementType = newPaiementType;
    print('New selected paiement type : ${state.paiementType}');
  }

  double get price => state.price;
  void setPrice({double newPrice}) {
    state.price = newPrice;
    print('price is now : ${state.price}');
  }

  String get note => state.note;
  void setNote({String newNote}) {
    state.note = newNote;
    print('New note is : ${state.note}');
  }

  bool get tp => state.tp;
  void setTp({bool newTp}) {
    state.tp = newTp;
    print('Tier payant is now : ${state.tp}');
  }

  DateTime get date => state.date;
  void setDate() {
    state.date = DateTime.now();
    print('Date is now : ${state.date}');
  }

  Workplace get workplace => _medecinStateNotifier.state.selectedWorkplace;
}
