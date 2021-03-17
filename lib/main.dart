import 'package:assistant_compta_medge/app/router.gr.dart';
import 'package:assistant_compta_medge/services/shared_preference_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('fr_Fr');
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      // override the previous value with the new object
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyApp()');
    return MaterialApp(
      theme: ThemeData(textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16))),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: Router().onGenerateRoute,
      // initialRoute: Routes.homeView,
      title: 'Click & Collect',
    );
  }
}
