import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class Inscripccion extends StatelessWidget {
  const Inscripccion({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      // Este builder mantiene el RouterScope correcto
      builder: (context, child) => Scaffold(
        body: child,
      ),
    );
  }
}
