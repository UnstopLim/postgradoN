// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:postgrado/Feacture/Cursos/Presentacion/Page/Curs.dart' as _i1;
import 'package:postgrado/Feacture/ForgotYouPassword/Presentacion/Page/ForgotYouPass.dart'
    as _i2;
import 'package:postgrado/Feacture/Home/Presentacion/Page/Home.dart' as _i3;
import 'package:postgrado/Feacture/Login/Presentacion/Page/Login.dart' as _i4;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    Curs.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.Curs(),
      );
    },
    ForgotyouPass.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotyouPass(),
      );
    },
    Home.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.Home(),
      );
    },
    Login.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.Login(),
      );
    },
  };
}

/// generated route for
/// [_i1.Curs]
class Curs extends _i5.PageRouteInfo<void> {
  const Curs({List<_i5.PageRouteInfo>? children})
      : super(
          Curs.name,
          initialChildren: children,
        );

  static const String name = 'Curs';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgotyouPass]
class ForgotyouPass extends _i5.PageRouteInfo<void> {
  const ForgotyouPass({List<_i5.PageRouteInfo>? children})
      : super(
          ForgotyouPass.name,
          initialChildren: children,
        );

  static const String name = 'ForgotyouPass';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.Home]
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
/// [_i4.Login]
class Login extends _i5.PageRouteInfo<void> {
  const Login({List<_i5.PageRouteInfo>? children})
      : super(
          Login.name,
          initialChildren: children,
        );

  static const String name = 'Login';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
