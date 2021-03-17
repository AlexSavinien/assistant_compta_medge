import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/dialog_service.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  FirestoreService _firestoreService = ref.watch(firestoreProvider);
  DialogService _dialogService = ref.watch(dialogServiceProvider);
  return HomeViewModel(
    _firestoreService,
    _dialogService,
  );
});

class HomeViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final DialogService _dialogService;

  HomeViewModel(
    this._firestoreService,
    this._dialogService,
  );

  /// =========================== Type de paiement ==========================
  List<Map<String, String>> get paiementTypes => _paiementTypes;
  final List<Map<String, String>> _paiementTypes = [
    {'value': 'cb', 'title': 'CB'},
    {'value': 'espece', 'title': 'Espèce'},
    {'value': 'cheque', 'title': 'Chéque'},
    {'value': 'virement', 'title': 'Virement'},
    {'value': 'ald', 'title': 'ALD'},
  ];
  String _paiementType;
  String get paiementType => _paiementType;
  void setPaiementType({String newPaiementType}) {
    _paiementType = newPaiementType;
    print('New selected paiement type : $paiementType');
  }

  /// =========================== Choix du cabinet ==========================
  Workplace _selectedWorkplace;
  Workplace get selectedWorkplace => _selectedWorkplace;
  void setSelectedWorkplace({Workplace workplace}) {
    _selectedWorkplace = workplace;
    print('Selected workplaces is ${selectedWorkplace.name} with id ${selectedWorkplace.id}');
    notifyListeners();
  }

  /// ============================== Prix ==================================
  double _price = 25;
  double get price => _price;
  void setPrice({double newPrice}) {
    _price = newPrice;
    print('price is now : ${price.toString()}');
  }

  /// =========================== Tier Payant =============================
  bool _tp = false;
  bool get tp => _tp;
  void setTp({bool newTp}) {
    _tp = newTp;
    print('Tier payant is now : ${_tp.toString()}');
    notifyListeners();
  }

  /// ============================== Note ================================
  String _note;
  String get note => _note;
  void setNote({String newNote}) {
    _note = newNote;
    print('New note is : $note');
  }

  /// ========================= Dernière Consultation =========================
  Stream<QuerySnapshot> getLastConsultations({Workplace worplace}) {
    Stream<QuerySnapshot> stream = _firestoreService.getConsultationsAsAStream();
    return stream;
  }

  /// =========================== Ajout Consultation =============================
  Future<void> addConsult() async {
    if (_selectedWorkplace == null || _price == null || _price == 0 || _paiementType == null) {
      await _dialogService.showDialog(
          title: 'Erreur',
          description:
              'Pour ajouter une consultation, vous devez avoir sélectionné un cabinet, un prix supérieur à 0 et un type de paiement');
    } else {
      Consultation consultation = Consultation(
        price: _price,
        paiementType: _paiementType,
        date: Timestamp.now(),
        tp: _tp,
        note: _note,
        workplace: _selectedWorkplace,
      );
      await _firestoreService.addConsultation(consultation: consultation);
    }
  }

  /// =========================== Delete Consultation =============================

  Future<void> deleteConsultation({Consultation consultation}) async {
    var res = await _dialogService.showConfirmationDialog(
        title: 'Confirmation',
        description:
            'Voulez-vous supprimer la consultation de ${DateFormat.Hm().format(consultation.date.toDate())}, payé par ${consultation.paiementType}',
        confirmationTitle: 'Oui',
        cancelTitle: 'Non');
    res.confirmed
        ? await _firestoreService.deleteConsultation(
            consultation: consultation,
            workplaceId: selectedWorkplace.id,
          )
        : print(
            'Annulation de la suppression de la consultation de ${DateFormat.Hm().format(consultation.date.toDate())}, payé par ${consultation.paiementType}');
  }
}
