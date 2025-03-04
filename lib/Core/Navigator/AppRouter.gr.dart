// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:postgrado/Feacture/CambiarPassword/presentacion/page/Cambio.dart'
    as _i1;
import 'package:postgrado/Feacture/Home/Presentacion/Page/Home.dart' as _i2;
import 'package:postgrado/Feacture/Home/Presentacion/Page/HomeBody.dart' as _i3;
import 'package:postgrado/Feacture/Home/Presentacion/Page/snap.dart' as _i7;
import 'package:postgrado/Feacture/Login/Presentacion/Page/Login.dart' as _i4;
import 'package:postgrado/Feacture/Perfil/presentacion/page/Perfil.dart' as _i5;
import 'package:postgrado/Feacture/REcuperar/presentacion/page/Recuperar.dart'
    as _i6;

abstract class $AppRouter extends _i8.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    Cambio.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.Cambio(),
      );
    },
    Home.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Home(),
      );
    },
    HomeBody.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeBody(),
      );
    },
    Login.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.Login(),
      );
    },
    Perfil.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.Perfil(),
      );
    },
    Recuperar.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.Recuperar(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i8.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.Cambio]
class Cambio extends _i8.PageRouteInfo<void> {
  const Cambio({List<_i8.PageRouteInfo>? children})
      : super(
          Cambio.name,
          initialChildren: children,
        );

  static const String name = 'Cambio';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i2.Home]
class Home extends _i8.PageRouteInfo<void> {
  const Home({List<_i8.PageRouteInfo>? children})
      : super(
          Home.name,
          initialChildren: children,
        );

  static const String name = 'Home';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomeBody]
class HomeBody extends _i8.PageRouteInfo<void> {
  const HomeBody({List<_i8.PageRouteInfo>? children})
      : super(
          HomeBody.name,
          initialChildren: children,
        );

  static const String name = 'HomeBody';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i4.Login]
class Login extends _i8.PageRouteInfo<void> {
  const Login({List<_i8.PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i5.Perfil]
class Perfil extends _i8.PageRouteInfo<void> {
  const Perfil({List<_i8.PageRouteInfo>? children})
      : super(
          Perfil.name,
          initialChildren: children,
        );

  static const String name = 'Perfil';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i6.Recuperar]
class Recuperar extends _i8.PageRouteInfo<void> {
  const Recuperar({List<_i8.PageRouteInfo>? children})
      : super(
          Recuperar.name,
          initialChildren: children,
        );

  static const String name = 'Recuperar';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashScreen]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i8.PageInfo<void> page = _i8.PageInfo<void>(name);
}
