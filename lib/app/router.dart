import 'package:assistant_compta_medge/ui/views/authentification/signin/signin_view.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signup/signup_view.dart';
import 'package:assistant_compta_medge/ui/views/authentification/startup/startup_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/menu_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/add_worplace/add_workplace_view.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/profile_view/profil_view.dart';
import 'package:auto_route/auto_route_annotations.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  routes: <AutoRoute>[
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: MenuView),
    MaterialRoute(page: SignInView),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: AddWorkPlaceView),
    MaterialRoute(page: ProfileView),
  ],
)
class $Router {}
