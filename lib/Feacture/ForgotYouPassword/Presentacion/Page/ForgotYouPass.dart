import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ForgotyouPass extends StatefulWidget {
  const ForgotyouPass({super.key});

  @override
  State<ForgotyouPass> createState() => _ForgotyouPassState();
}

class _ForgotyouPassState extends State<ForgotyouPass> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Fondo azul con el logo
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.shade900],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.school, // Aquí puedes poner tu logo
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              // Formulario flotante
              Positioned(
                top: screenHeight * 0.22, // Ajuste para que sobresalga
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Evita que se expanda innecesariamente
                    children: [
                      Text(
                        'Olvidaste tu contraseña',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );

  }
}

