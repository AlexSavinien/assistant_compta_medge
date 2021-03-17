import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final firestoreProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(
    ref.watch(authentificationServiceProvider),
  );
});

class FirestoreService {
  final AuthentificationService _auth;

  FirestoreService(
    this._auth,
  );

  CollectionReference medecins = FirebaseFirestore.instance.collection('medecin');

  Future<void> signOut() async {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
  }

  /// =========================================================================
  /// =========================== Medecins CRUD ===============================
  /// =========================================================================

  Future<void> addMedecin({Medecin medecin}) async {
    String id = _auth.currentUser.uid;
    medecin.id = id;
    await medecins
        .doc(id)
        .set(medecin.toJson())
        .then((value) => print('User added'))
        .catchError((e) => print('Failed to add user : $e'));
  }

  Future<Medecin> getMedecin() async {
    String id = _auth.currentUser.uid;
    DocumentSnapshot medecinData = await medecins.doc(id).get();
    Medecin medecin = Medecin.fromJson(medecinData.data());
    print('Medecin get from Firebase : ${medecin.toString()}');
    return medecin;
  }

  Stream<DocumentSnapshot> getMedecinAsStream() {
    String id = _auth.currentUser.uid;
    Stream<DocumentSnapshot> stream = medecins.doc(id).snapshots();
    return stream;
  }

  Future<void> updateMedecin({String fieldName, dynamic newValue}) async {
    String id = _auth.currentUser.uid;
    medecins.doc(id).update({fieldName: newValue});
    print('Medecin $fieldName has been updated to ${newValue.toString()}');
    if (fieldName == 'email') {
      await _auth.currentUser.updateEmail(newValue);
      print(_auth.currentUser.email);
    }
  }

  Future<void> updateMedecinPreferences({String fieldName, dynamic newValue}) async {
    String id = _auth.currentUser.uid;
    medecins.doc(id).set({
      'preferences': {fieldName: newValue}
    }, SetOptions(merge: true));
  }

  Future<void> delete() async {
    //TODO
  }

  /// =========================================================================
  /// =========================== Workplace CRUD ==============================
  /// =========================================================================

  Future<void> addWorkplace({Workplace workplace}) async {
    String id = _auth.currentUser.uid;
    await medecins
        .doc(id)
        .collection('workplaces')
        .add(workplace.toJson())
        .then((value) => print('Workplace ${workplace.name} added'))
        .catchError((e) => print('Failed to add Workplace : $e'));
  }

  Future<Workplace> getWorkplace({String name}) async {
    String id = _auth.currentUser.uid;
    Workplace workplace;

    QuerySnapshot res =
        await medecins.doc(id).collection('workplaces').where('name', isEqualTo: name).get();

    res.docs.forEach((doc) {
      String workplaceName = doc['name'];
      if (workplaceName == name) {
        String workplaceId = doc.id;
        workplace = Workplace(name: workplaceName, id: workplaceId);
      }
    });
    return workplace;
  }

  Stream<QuerySnapshot> getWorkplacesAsStream() {
    if (_auth.currentUser != null) {
      String id = _auth.currentUser.uid;
      Stream<QuerySnapshot> stream = medecins.doc(id).collection('workplaces').snapshots();
      print('stream is : $stream');
      return stream;
    } else {
      print('no user detected, empty stream of workplaces send from firestoreService');
      return Stream.empty();
    }
  }

  Future<QuerySnapshot> getWorkplaces() async {
    String id = _auth.currentUser.uid;
    QuerySnapshot res = await medecins.doc(id).collection('workplaces').get();
    return res;
  }

  Future<void> updateWorkplace({Workplace workplace}) async {
    String id = _auth.currentUser.uid;
    await medecins.doc(id).collection('workplaces').doc(workplace.id).set(workplace.toJson());
  }

  Future<void> updatePreviousDefaultWorkplace() async {
    String id = _auth.currentUser.uid;
    await medecins
        .doc(id)
        .collection('workplaces')
        .where('isDefault', isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.length == 1) {
        medecins.doc(id).collection('workplaces').doc(value.docs.first.id).set(
          {'isDefault': false},
          SetOptions(merge: true),
        );
      }
    });
  }

  Future<void> deleteWorkplace({String name}) async {
    String id = _auth.currentUser.uid;
    Workplace workplace = await getWorkplace(name: name);
    try {
      await medecins.doc(id).collection('workplaces').doc(workplace.id).delete();
      print('Workplace with id : ${workplace.id} has been deleted.');
    } on FirebaseException catch (e) {
      print('FirebaseException is : $e');
    }
  }

  /// =========================================================================
  /// =========================== Consultations CRUD ==========================
  /// =========================================================================

  Future<void> addConsultation({Consultation consultation}) async {
    String id = _auth.currentUser.uid;
    Workplace workplace = consultation.workplace;
    try {
      await medecins
          .doc(id)
          .collection('workplaces')
          .doc(workplace.id)
          .collection('consultations')
          .add(consultation.toJson());
      print('Consultation ${consultation.toJson()} has been added to ${workplace.name}');
    } on FirebaseException catch (e) {
      print('FirebaseException is : $e');
    }
  }

  Future<void> getConsultation({Consultation consultation}) async {
    //TODO
  }

  Future<List<Consultation>> getConsultations({Workplace workplace}) async {
    List<Consultation> consultations = [];
    String id = _auth.currentUser.uid;
    var res = await medecins
        .doc(id)
        .collection('workplaces')
        .doc(workplace.id)
        .collection('consultations')
        .get();
    res.docs.forEach((doc) {
      Consultation consultation = Consultation.fromJson(doc.data());
      consultations.add(consultation);
    });
    return consultations;
  }

  Future<void> updateConsultation({Consultation consultation}) async {
    //TODO
  }

  Future<void> deleteConsultation({Consultation consultation, String workplaceId}) async {
    String id = _auth.currentUser.uid;

    medecins
        .doc(id)
        .collection('workplaces')
        .doc(workplaceId)
        .collection('consultations')
        .doc(consultation.id)
        .delete();
    print(
        'Consultation du ${DateFormat.Md('fr_FR').format(consultation.date.toDate())} à ${DateFormat.Hm('fr_FR').format(consultation.date.toDate())} au prix de ${consultation.price}€ payé en ${consultation.paiementType} a bien été supprimé du cabinet ${consultation.workplace}');
  }

  Stream<QuerySnapshot> getConsultationsAsAStream({Workplace workplace}) {
    String id = _auth.currentUser.uid;
    Stream<QuerySnapshot> stream = medecins
        .doc(id)
        .collection('workplaces')
        .doc(workplace.id.toString())
        .collection('consultations')
        .orderBy('date')
        .snapshots();
    return stream;
  }

  Stream<QuerySnapshot> getMonthConsultationsAsAStream({Workplace workplace, DateTime dateTime}) {
    String id = _auth.currentUser.uid;
    String date = DateFormat('yMMMM', 'fr_FR').toString();
    String month = date.split(' ')[0];
    String year = date.split(' ')[1];
    print('date is $month, $year');
    Stream<QuerySnapshot> stream = medecins
        .doc(id)
        .collection('workplaces')
        .doc(workplace.id.toString())
        .collection('consultations')
        .where('date',
            isGreaterThanOrEqualTo: DateTime(dateTime.year, dateTime.month),
            isLessThanOrEqualTo: DateTime(dateTime.year, dateTime.month + 1))
        .orderBy('date')
        .snapshots();
    return stream;
  }
}
