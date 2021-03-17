// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:assistant_compta_medge/ui/views/authentification/signin/signin_view.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signup/signup_view.dart';
import 'package:assistant_compta_medge/ui/views/authentification/startup/startup_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/menu_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/add_worplace/add_workplace_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/profile_view/profil_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String startUpView = '/';
  static const String menuView = '/menu-view';
  static const String signInView = '/sign-in-view';
  static const String signUpView = '/sign-up-view';
  static const String addWorkPlaceView = '/add-work-place-view';
  static const String profileView = '/profile-view';
  static const all = <String>{
    startUpView,
    menuView,
    signInView,
    signUpView,
    addWorkPlaceView,
    profileView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.menuView, page: MenuView),
    RouteDef(Routes.signInView, page: SignInView),
    RouteDef(Routes.signUpView, page: SignUpView),
    RouteDef(Routes.addWorkPlaceView, page: AddWorkPlaceView),
    RouteDef(Routes.profileView, page: ProfileView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StartUpView(),
        settings: data,
      );
    },
    MenuView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MenuView(),
        settings: data,
      );
    },
    SignInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInView(),
        settings: data,
      );
    },
    SignUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignUpView(),
        settings: data,
      );
    },
    AddWorkPlaceView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddWorkPlaceView(),
        settings: data,
      );
    },
    ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProfileView(),
        settings: data,
      );
    },
  };
}
