import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Consultation {
  String id;
  double price = 25;
  String paiementType;
  bool tp = false;
  Timestamp date;
  String note;
  Workplace workplace;

  Consultation(
      {this.id, this.price, this.paiementType, this.tp, this.date, this.note, this.workplace});

  Consultation.fromJson(Map<String, dynamic> data)
      : price = data['price'],
        paiementType = data['paiementType'],
        date = data['date'],
        tp = data['tp'],
        note = data['note'];

  Map<String, dynamic> toJson() => {
        'price': price,
        'paiementType': paiementType,
        'date': date,
        'note': note,
        'tp': tp,
      };
}
