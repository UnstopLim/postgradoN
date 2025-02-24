// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:postgrado/Feacture/Home/Presentacion/Page/Home.dart' as _i1;
import 'package:postgrado/Feacture/Login/Presentacion/Page/Login.dart' as _i2;
import 'package:postgrado/Feacture/Perfil/presentacion/page/Perfil.dart' as _i3;
import 'package:postgrado/Feacture/REcuperar/presentacion/page/Recuperar.dart'
    as _i4;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    Home.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.Home(),
      );
    },
    Login.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.Login(),
      );
    },
    Perfil.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.Perfil(),
      );
    },
    Recuperar.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.Recuperar(),
      );
    },
  };
}

/// generated route for
/// [_i1.Home]
class Home extends _i5.PageRouteInfo<void> {
  const Home({List<_i5.PageRouteInfo>? children})
      : super(
          Home.name,
          initialChildren: children,
        );

  static const String name = 'Home';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i2.Login]
class Login extends _i5.PageRouteInfo<void> {
  const Login({List<_i5.PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.Perfil]
class Perfil extends _i5.PageRouteInfo<void> {
  const Perfil({List<_i5.PageRouteInfo>? children})
      : super(
          Perfil.name,
          initialChildren: children,
        );

  static const String name = 'Perfil';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i4.Recuperar]
class Recuperar extends _i5.PageRouteInfo<void> {
  const Recuperar({List<_i5.PageRouteInfo>? children})
      : super(
          Recuperar.name,
          initialChildren: children,
        );

  static const String name = 'Recuperar';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
