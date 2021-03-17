import 'dart:io';

import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final consultationsViewModelProvider = ChangeNotifierProvider<ConsultationsViewModel>((ref) {
  return ConsultationsViewModel();
});

class ConsultationsViewModel extends ChangeNotifier {
  ConsultationsViewModel();

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setSelectedDate({DateTime newDate}) {
    _selectedDate = newDate;
    print('New selected month is ${DateFormat('yMMMM').format(_selectedDate)}');
    notifyListeners();
  }

  Future<File> getCsv({AsyncValue<List<Consultation>> list, Workplace workplace}) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } //
    print('Permission storage status is : $status');

    // the downloads folder path
    // var tempDir = await getExternalStorageDirectories(type: StorageDirectory.downloads);
    // print('Path is : ${tempDir[1]}');

    String tempPath = '/storage/emulated/0/Download';
    String fileName = "export_${DateFormat('yMMMM').format(_selectedDate)}.csv";
    var filePath = tempPath + '/$fileName';
    print('FilePath is : $filePath');

    double monthTotal = 0;

    List<List<dynamic>> finalList = [
      [
        'Comptabilite pour le cabinet ${workplace.name} au mois de ${DateFormat('yMMMM').format(_selectedDate)}',
        'total du mois =',
        monthTotal
      ],
      ['id', 'prix', 'Moyen de paiement', 'Tier-payant', 'date', 'heure', 'notes'],
    ];

    var consultationList = list.whenData((list) {
      print('List : $list');
      return list.forEach((consultation) {
        print('Consultation : ${consultation.toJson().toString()}');
        finalList[0][2] += consultation.price;
        if (consultation.paiementType == 'Espèce') {
          consultation.paiementType = 'Espece';
        }
        finalList.add([
          consultation.id,
          consultation.price,
          consultation.paiementType,
          consultation.tp ? 'oui' : 'non',
          '${DateFormat('yMd', 'fr_Fr').format(consultation.date.toDate())}',
          '${DateFormat('jms', 'fr_Fr').format(consultation.date.toDate())}',
          consultation.note
        ]);
      });
      print('final list is : $list');
    });

    print('List : $finalList');
    String csv = ListToCsvConverter().convert(finalList);
    // save the data in the path
    return File(filePath).writeAsString(csv);
  }
}
