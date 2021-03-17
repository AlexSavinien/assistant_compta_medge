import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signin/signin_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/menu_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartUpView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    print('StartUpView()');
    return useProvider(authStateChangesProvider).when(
      data: (res) {
        bool isUserLoggedIn = false;
        if (res != null) {
          print('User is : ${res.uid}');
          isUserLoggedIn = true;
        }
        print('isUserLoggedIn ? $isUserLoggedIn');
        return isUserLoggedIn ? MenuView() : SignInView();
      },
      loading: () {
        return CircularProgressIndicator();
      },
      error: (err, stack) {
        return Text('Error : ${err.toString()}, Stack : ${stack.toString()}');
      },
    );
  }
}
