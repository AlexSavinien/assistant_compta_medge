import 'package:assistant_compta_medge/models/preferences/preferences.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final preferencesProvider = StreamProvider.autoDispose<Preferences>((ref) async* {
  FirestoreService _firestoreService = ref.watch(firestoreProvider);

  Stream<DocumentSnapshot> stream = _firestoreService.getMedecinAsStream();

  await for (final value in stream) {
    print(
        'value.data() is : ${value.data()['preferences']['defaultPaiementType']} -- prefprovider');
    yield Preferences(
        defaultWorkplace:
            Workplace(name: value.data()['preferences']['defaultWorkplace'], id: value.id),
        defaultPrice: double.parse(value.data()['preferences']['defaultPrice']),
        defaultPaiementType: value.data()['preferences']['defaultPaiementType']);
  }
});
