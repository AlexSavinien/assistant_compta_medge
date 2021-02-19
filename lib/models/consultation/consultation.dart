import 'package:assistant_compta_medge/models/workplace/workplace.dart';

class Consultation {
  String id;
  double price;
  String paiementType;
  bool tp;
  DateTime date;
  String note;
  Workplace workplace;

  Consultation(
      {this.id,
      this.price,
      this.paiementType,
      this.tp,
      this.date,
      this.note,
      this.workplace});

  Consultation.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        price = data['price'],
        paiementType = data['paiementType'],
        date = data['date'],
        tp = data['tp'],
        note = data['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'paiementType': paiementType,
        'date': date,
        'note': note,
        'tp': tp,
      };

  List<Map<String, String>> get paiementTypes => _paiementTypes;
  final List<Map<String, String>> _paiementTypes = [
    {'value': 'cb', 'title': 'CB'},
    {'value': 'espece', 'title': 'Espèce'},
    {'value': 'cheque', 'title': 'Chéque'},
    {'value': 'virement', 'title': 'Virement'},
  ];
}
