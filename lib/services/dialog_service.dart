import 'package:flutter_riverpod/all.dart';
import 'package:stacked_services/stacked_services.dart';

final dialogServiceProvider = Provider<DialogService>((ref) {
  return DialogService();
});
