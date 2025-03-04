import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  // FocusNodes para manejar el desplazamiento al enfocar los campos
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // Limpiar los FocusNodes cuando el widget se destruya
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Color(0xFFEAEAEA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Permitir que el scroll se active al arrastrar
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // Fondo degradado
                    Container(
                      height: isLandscape ? screenHeight * 0.4 : screenHeight * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF230000), Color(0xFF002A55), Color(0xFF004D97)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(80),
                        ),
                      ),
                    ),

                    // Logo centrado
                    Positioned(
                      top: screenHeight * 0.10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/logo2.png",
                          width: screenWidth * 0.35,
                          height: screenWidth * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Contenedor principal
                    Positioned(
                      top: isLandscape ? screenHeight * 0.15 : screenHeight * 0.33,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 5))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              "Bienvenido",
                              style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                            ),
                            Text(
                              "A Posgrado Token",
                              style: TextStyle(color: Color(0xFF700015), fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            // Campo de email con icono
                            TextField(
                              controller: emailController,
                              focusNode: emailFocusNode, // Asignar el FocusNode
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "E-Mail",
                                prefixIcon: Icon(Icons.email, color: Colors.black54),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Campo de contraseña con icono y botón de visibilidad
                            TextField(
                              controller: passwordController,
                              focusNode: passwordFocusNode, // Asignar el FocusNode
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock, color: Colors.black54),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Checkbox "Recordar contraseña"
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  activeColor: Color(0xFF00397C),
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "Recordar contraseña",
                                  style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Botón de inicio de sesión
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.router.push(Home());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF00397C),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                                ),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Botón "Olvidaste tu contraseña?"
                            TextButton(
                              onPressed: () {
                                context.router.push(Recuperar());
                              },
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: TextStyle(fontSize: screenWidth * 0.04, color: Color(0xFF000000), fontWeight: FontWeight.bold),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
