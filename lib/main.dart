import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:postgrado/Core/Navigator/AppRouter.dart';
import 'package:postgrado/Core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'auth_token');
  await storage.delete(key: 'auth_token_expiration');


  setupLocator();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _app_router =AppRouter();


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _app_router.config(),
      //home: TimerButtonPage(),
    );
  }
}
















