import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/CustomAppBar.dart';

@RoutePage()
class Recuperar extends StatefulWidget {
  const Recuperar({super.key});
  @override
  State<Recuperar> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<Recuperar> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController num1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,  // Fondo blanco para la pantalla
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.0,  // Hacemos que la imagen sea opaca
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock_reset_rounded, size: 100, color: Color(0xFF0056A6)),
                  const SizedBox(height: 15),

                  // Contenedor de los datos (ahora transparente)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02,
                      horizontal: screenSize.width * 0.10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,  // Fondo transparente
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.010),
                        Text(
                          "Ingresa tu correo y te enviaremos un enlace para recuperar tu cuenta.",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Campo de texto para el correo electrónico
                  TextField(
                    controller: num1,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Correo electronico",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),  // Fondo transparente para los campos de texto
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro cuando está enfocado
                        borderRadius: BorderRadius.circular(52),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Aquí iría la lógica para enviar el enlace
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF003D78),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Enviar enlace", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Regresar al inicio de sesión",
                      style: TextStyle(fontSize: 16, color: Color(0xFF00294C), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}






