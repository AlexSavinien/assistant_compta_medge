import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';

final firestoreProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(ref.watch(authentificationServiceProvider),
      ref.watch(medecinNotifierProvider.state));
});

class FirestoreService {
  final AuthentificationService _auth;
  final Medecin _medecin;
  // MedecinStateNotifier _medecinStateNotifier;

  FirestoreService(this._auth, this._medecin);

  CollectionReference medecins =
      FirebaseFirestore.instance.collection('medecin');

  /// =========================================================================
  /// =========================== Getter / Setter =============================
  /// =========================================================================
  Medecin get medecinStateNotifier => _medecin;

  /// =========================================================================
  /// =========================== Medecins CRUD ===============================
  /// =========================================================================

  Future<void> addMedecin({Medecin medecin}) async {
    String id = _auth.currentUser.uid;
    medecin.id = id;
    medecins
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

  Future<void> updateMedecin() async {
    //TODO
  }
  Future<void> delete() async {
    //TODO
  }

  /// =========================================================================
  /// =========================== Workplace CRUD ==============================
  /// =========================================================================

  Future<void> addWorkplace({String name}) async {
    String id = _auth.currentUser.uid;
    Workplace workplace = Workplace(name: name);
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

    QuerySnapshot res = await medecins
        .doc(id)
        .collection('workplaces')
        .where('name', isEqualTo: name)
        .get();

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
    String id = _auth.currentUser.uid;
    List<Workplace> workplaces = [];
    Stream<QuerySnapshot> stream =
        medecins.doc(id).collection('workplaces').snapshots();

    // Ajoute de la list de workspace au state du medecin
    stream.last.then((value) {
      value.docs.map((e) {
        workplaces.add(Workplace.fromJson(e.data()));
      });
    });
    _medecin.workplaces = workplaces;
    return stream;
  }

  Future<List<Workplace>> getWorkplaces() async {
    String id = _auth.currentUser.uid;
    List<Workplace> workplaces = [];
    var res = await medecins.doc(id).collection('workplaces').get();
    res.docs.forEach((doc) {
      String workplaceName = doc['name'];
      String workplaceId = doc.id;
      Workplace workplace = Workplace(id: workplaceId, name: workplaceName);
      workplaces.add(workplace);
    });
    return workplaces;
  }

  Future<void> updateWorkplace() async {
    //TODO
  }

  Future<void> deleteWorkplace({String name}) async {
    String id = _auth.currentUser.uid;
    Workplace workplace = await getWorkplace(name: name);
    try {
      await medecins
          .doc(id)
          .collection('workplaces')
          .doc(workplace.id)
          .delete();
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
      print(
          'Consultation ${consultation.toJson()} has been added to ${workplace.name}');
    } on FirebaseException catch (e) {
      print('FirebaseException is : $e');
    }
  }

  Future<void> getConsultation(Consultation consultation) async {
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

  Future<void> updateConsultation(Consultation consultation) async {
    //TODO
  }

  Future<void> deleteConsultation(Consultation consultation) async {
    //TODO
  }
}
