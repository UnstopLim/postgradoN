import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';


@RoutePage()
class Paso2Page extends StatelessWidget {
  const Paso2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Paso 2: Subir imágenes"),
          ElevatedButton(
            onPressed: () => context.pushRoute(Paso3Route()),
            child: Text("Siguiente"),
          ),
        ],
      ),
    );
  }
}