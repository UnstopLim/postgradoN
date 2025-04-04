import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Iniciar la animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // La animación dura 2 segundos
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    // Esperamos 3 segundos más y pasamos a la pantalla principal
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.router.replace(Login()); // Transición al login
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF002C47), Color(0xFF001225), Color(0xFF00375A)], // Degradado de fondo
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/LOGON.png',
              width: 200, // Tamaño del logo
            ),
          ),
        ),
      ),
    );
  }
}
