import 'package:assistant_compta_medge/models/workplace/workplace.dart';

class Medecin {
  String id;
  String firstname;
  String lastname;
  String email;
  List<Workplace> workplaces = [];
  Workplace selectedWorkplace;

  Medecin(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.workplaces,
      this.selectedWorkplace})
      : super();

  Medecin.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        firstname = data['firstname'],
        lastname = data['lastname'],
        email = data['email'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
      };
}
