import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class Paso3Page extends StatelessWidget {
  const Paso3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Paso 3: Confirmar"),
    );
  }
}
