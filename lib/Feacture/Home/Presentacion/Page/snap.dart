import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage() // Marca esta clase como una página de AutoRoute
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _scale = 0.0; // Inicializamos la escala
  bool _visible = false; // Controlamos la visibilidad del logo

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  // Método para iniciar la animación y la navegación
  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0; // Logo se hace más grande
        _visible = true; // El logo se hace visible
      });
    });

    // Navegar a la siguiente pantalla después de 4 segundos
    Future.delayed(Duration(seconds: 4), () {
      context.pushRoute(Login()); // Navegar a la página principal usando auto_route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF005B97), // Azul claro en la parte superior
              Color(0xFF001D3A), // Azul oscuro en el medio
              Color(0xFF005B97), // Azul medio en la parte inferior
            ],
            stops: [0.0, 0.5, 1.0], // Controla la distribución del degradado
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0, // Controlamos la opacidad
                duration: Duration(seconds: 2),
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: _scale), // Animación de escala
                  duration: Duration(seconds: 2),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale, // Aplica la escala al logo
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/logo1.png', // Asegúrate de colocar tu logo en assets y configurarlo en pubspec.yaml
                    width: 200, // Ajusta el tamaño según tu logo
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Version',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                '1.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
