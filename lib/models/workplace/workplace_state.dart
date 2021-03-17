import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final workplacesStreamProvider = StreamProvider.autoDispose<List<Workplace>>((ref) async* {
  final FirestoreService _firestoreService = ref.watch(firestoreProvider);
  Stream<QuerySnapshot> stream = _firestoreService.getWorkplacesAsStream();

  await for (final value in stream) {
    print('Value from stream is : ${value.docs.length}');
    yield value.docs
        .map((e) => Workplace(name: e.data()['name'], id: e.id, isDefault: e.data()['isDefault']))
        .toList();
  }
});

final defaultWorkplaceProvider = StreamProvider.autoDispose<Workplace>((ref) async* {
  Workplace defaultWorkplace =
      ref.watch(workplacesStreamProvider)?.data?.value?.firstWhere((element) {
    return element.isDefault == true;
  });
  yield defaultWorkplace;
});
