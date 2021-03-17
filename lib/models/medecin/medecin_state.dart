import 'package:assistant_compta_medge/models/medecin/medecin.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final medecinProvider = StreamProvider.autoDispose<Medecin>((ref) async* {
  final FirestoreService _firestoreService = ref.watch(firestoreProvider);
  Stream<DocumentSnapshot> stream = _firestoreService.getMedecinAsStream();
  print('Med stream working');
  await for (final value in stream) {
    Medecin medecin = Medecin.fromJson(value.data());
    medecin.id = value.id;
    print('medecin is ${medecin.toJson()}');
    yield medecin;
  }
});
