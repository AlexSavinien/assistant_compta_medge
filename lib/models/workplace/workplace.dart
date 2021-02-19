import 'package:assistant_compta_medge/models/medecin/medecin.dart';

class Workplace {
  String id;
  String name;
  Medecin medecin;

  Workplace({this.id, this.name, this.medecin});

  Workplace.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
