import 'package:assistant_compta_medge/models/workplace/workplace.dart';

class Preferences {
  double defaultPrice;
  String defaultPaiementType;
  Workplace defaultWorkplace;

  Preferences({this.defaultPrice, this.defaultPaiementType, this.defaultWorkplace});

  Preferences.fromJson(Map<String, dynamic> data)
      : defaultPrice = data['defaultPrice'],
        defaultPaiementType = data['defaultPaiementType'],
        defaultWorkplace = data['defaultWorkplace'];

  Map<String, dynamic> toJson() => {
        'defaultPrice': defaultPrice,
        'defaultPaiementType': defaultPaiementType,
        'defaultWorkplace': defaultWorkplace,
      };
}
