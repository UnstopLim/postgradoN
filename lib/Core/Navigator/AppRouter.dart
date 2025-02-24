
import 'package:auto_route/auto_route.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';





@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: Login.page, initial: true),
    AutoRoute(page: Recuperar.page),
    AutoRoute(page: Home.page),
    AutoRoute(page: Perfil.page)
  ];
}
