import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
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
              Image.asset(
                'assets/logo1.png', // Asegúrate de colocar tu logo en assets y configurarlo en pubspec.yaml
                width: 200, // Ajusta el tamaño según tu logo
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