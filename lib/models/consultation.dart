class Consultation {
  String id;
  double price;
  String paiementType;
  DateTime date;
  String note;

  Consultation(this.id, this.price, this.paiementType, this.date, this.note);

  Consultation.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        price = data['price'],
        paiementType = data['paiementType'],
        date = data['date'],
        note = data['note'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'paiementType': paiementType,
        'date': date,
        'note': note,
      };
}
