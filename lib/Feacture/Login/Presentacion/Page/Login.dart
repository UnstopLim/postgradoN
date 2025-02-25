import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginDaoState();
}

class _LoginDaoState extends State<Login> {
  final TextEditingController num1 = TextEditingController();
  final TextEditingController num2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  height: isLandscape ? screenHeight * 0.4 : screenHeight * 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF230008), Color(0xFF00142B),Color(
                          0xFF00549F)], // Azul oscuro a azul
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  top: isLandscape ? screenHeight * 0.11 : screenHeight * 0.11, // Ajuste para subir más la imagen
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      "assets/logo2.png", // Reemplázalo con la dirección de tu imagen
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: isLandscape ? screenHeight * 0.3 : screenHeight * 0.36,
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 2, offset: Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Bienvenido",
                          style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold,fontFamily: 'Roboto'),
                        ),
                        Text("A posgrado Token",style: TextStyle(color: Color(
                            0xFF700015),fontWeight: FontWeight.bold,fontSize: screenWidth * 0.04)
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        TextField(
                          controller: num1,
                          decoration: InputDecoration(
                            labelText: "E-Mail",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro cuando está enfocado
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        TextField(
                          controller: num2,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2), // Fondo cuando no está enfocado
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro cuando está enfocado
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ElevatedButton(
                          onPressed: () {
                            context.router.push(Home());
                          },
                          child: Text(" Log in", style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF002B5E),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                              horizontal: screenWidth * 0.2,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        TextButton(onPressed:() {context.router.push(Recuperar());}, child: Text("¿Olvidaste tu contraseña?",style: TextStyle(fontSize: screenWidth * 0.04,color: Color(
                            0xFF6A0000), fontWeight: FontWeight.bold))),
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
