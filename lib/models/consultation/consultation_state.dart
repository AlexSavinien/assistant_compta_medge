import 'dart:async';
import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/services/firestore_service.dart';
import 'package:assistant_compta_medge/ui/views/menu/consultations/consultations_viewmodel.dart';
import 'package:assistant_compta_medge/ui/views/menu/home/home_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final consultationStreamProvider = StreamProvider.autoDispose<List<Consultation>>((ref) async* {
  final FirestoreService _firestoreService = ref.watch(firestoreProvider);
  Workplace selectedWorkplace = ref.watch(homeViewModelProvider).selectedWorkplace;

  if (selectedWorkplace != null) {
    Stream<QuerySnapshot> stream = _firestoreService.getConsultationsAsAStream(
      workplace: selectedWorkplace,
    );

    yield* stream.map((snapshot) {
      return snapshot.docs
          .map((e) => Consultation(
                date: e.data()['date'],
                price: e.data()['price'],
                paiementType: e.data()['paiementType'],
                tp: e.data()['tp'],
                note: e.data()['note'],
                id: e.id,
              ))
          .toList();
    });
  } else {
    yield* Stream.empty();
  }
});

final monthConsultationsStreamProvider =
    StreamProvider.autoDispose<List<Consultation>>((ref) async* {
  final FirestoreService _firestoreService = ref.watch(firestoreProvider);
  Workplace selectedWorkplace = ref.watch(homeViewModelProvider).selectedWorkplace;
  DateTime selectedDate = ref.watch(consultationsViewModelProvider).selectedDate;

  if (selectedWorkplace != null) {
    Stream<QuerySnapshot> stream = _firestoreService.getMonthConsultationsAsAStream(
        workplace: selectedWorkplace, dateTime: selectedDate);
    yield* stream.map((snapshot) {
      return snapshot.docs
          .map((e) => Consultation(
                date: e.data()['date'],
                price: e.data()['price'],
                paiementType: e.data()['paiementType'],
                tp: e.data()['tp'],
                note: e.data()['note'],
                id: e.id,
              ))
          .toList();
    });
  } else {
    yield* Stream.empty();
  }
});
