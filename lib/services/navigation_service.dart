import 'package:flutter_riverpod/all.dart';
import 'package:stacked_services/stacked_services.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService();
});
