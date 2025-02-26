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
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // Agregar un post-frame callback para asegurar que la animación empieza correctamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });

    // Controlador de la animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Reducido para mejor rendimiento
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _startAnimation() {
    setState(() {
      _visible = true;
    });

    _controller.forward(); // Inicia la animación

    // Cambia de pantalla después de 3 segundos
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.pushRoute(Login());
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
            colors: [
              Color(0xFF005B97),
              Color(0xFF001D3A),
              Color(0xFF005B97),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation, // Opacidad animada con mejor rendimiento
                child: ScaleTransition(
                  scale: _animation, // Escalado animado eficiente
                  child: Image.asset(
                    'assets/logo1.png',
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Versión',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Text(
                '1.0',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}