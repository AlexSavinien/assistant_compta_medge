import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signin/signin_view.dart';
import 'package:assistant_compta_medge/ui/views/authentification/startup/startup_viewmodel.dart';
import 'package:assistant_compta_medge/ui/views/menu/menu_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class StartUpView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // var haveAWorkPlace = watch(firestoreProvider).haveAWorkplace();
    print('StartUpView()');
    return StreamBuilder(
        stream: watch(authentificationServiceProvider).onAuthStateChanged,
        builder: (context, AsyncSnapshot<User> snapshot) {
          print('StreamBuilder');
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot.connectionState.toString());
            final bool isUserLoggedIn = snapshot.hasData;

            // context.read(startUpViewModelProvider).updateMedecinInfo();
            print('isUserLoggedIn ? $isUserLoggedIn');
            return isUserLoggedIn ? MenuView() : SignInView();
          }
          print(
              'Current user : ${context.read(authentificationServiceProvider).currentUser.uid}');
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
