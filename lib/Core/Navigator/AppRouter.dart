import 'package:auto_route/auto_route.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/CustomAppBar.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/drawer.dart';


@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page),
    AutoRoute(page: Recuperar.page),
    AutoRoute(page: Login.page),
    AutoRoute(page: Home.page,initial: true, children: [
      AutoRoute(page: HomeBody.page, path: 'home'),
      AutoRoute(page: Perfil.page, path: 'perfil'),
      AutoRoute(page: Cambio.page, path: 'configuracion'),
      AutoRoute(page: Inscripccion.page,path: 'Inscripcciones',children: [
        AutoRoute(page: Paso1Route.page, path: ''),
        AutoRoute(page: Paso2Route.page),
        AutoRoute(page: Paso3Route.page),
      ]),
    ]),
  ];
}
