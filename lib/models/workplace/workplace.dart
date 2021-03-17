import 'package:assistant_compta_medge/models/medecin/medecin.dart';

class Workplace {
  String id;
  String name;
  Medecin medecin;
  bool isDefault;

  Workplace({this.id, this.name, this.medecin, this.isDefault});

  Workplace.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        isDefault = data['isDefault'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'isDefault': isDefault,
      };
}
