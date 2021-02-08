import 'package:assistant_compta_medge/ui/views/authentification/signin/signin_view.dart';
import 'package:assistant_compta_medge/ui/views/authentification/signup/signup_view.dart';
import 'package:assistant_compta_medge/ui/views/home/home_view.dart';
import 'package:auto_route/auto_route_annotations.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: HomeView,
      initial: true,
    ),
    MaterialRoute(page: SignInView),
    MaterialRoute(page: SignUpView),
  ],
)
class $Router {}
