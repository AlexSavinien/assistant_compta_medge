import 'package:flutter_riverpod/all.dart';

final authentificationServiceProvider =
    Provider<AuthentificationService>((ref) {
  return AuthentificationService();
});

class AuthentificationService {}
