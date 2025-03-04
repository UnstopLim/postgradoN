import 'package:auto_route/auto_route.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/CustomAppBar.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/drawer.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: Recuperar.page),
    AutoRoute(page: Login.page),
    AutoRoute(page: Home.page, children: [
      // Definir las rutas hijas de la página Home
      AutoRoute(page: HomeBody.page, path: 'home'),
      AutoRoute(page: Perfil.page, path: 'perfil'),
      AutoRoute(page: Cambio.page, path: 'configuracion'),
    ]),
  ];
}
