import 'package:assistant_compta_medge/models/workplace/workplace.dart';

class Medecin {
  String id;
  String firstname;
  String lastname;
  String email;
  List<Workplace> workplaces = [];
  Workplace selectedWorkplace;
  Map<String, dynamic> preferences = {
    'defaultPrice': null,
    'defaultWorkplace': null,
    'defaultPaiementType': null,
  };

  Medecin(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.workplaces,
      this.selectedWorkplace,
      this.preferences})
      : super();

  Medecin.fromJson(Map<String, dynamic> data)
      : firstname = data['firstname'],
        lastname = data['lastname'],
        email = data['email'],
        preferences = data['preferences'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'preferences': preferences
      };
}
