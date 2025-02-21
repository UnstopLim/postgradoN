import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/Home.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/snap.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _app_router =AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //routerConfig: _app_router.config(),
      home: SplashScreen(),
    );
  }
}
















