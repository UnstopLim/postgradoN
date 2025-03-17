import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';


@RoutePage()
class Cambio extends StatefulWidget {
  const Cambio({super.key});

  @override
  State<Cambio> createState() => _CambioState();
}

class _CambioState extends State<Cambio> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.0),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Cambio de Contraseña",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ingresa tu contraseña actual y la nueva",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),

                  // Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPasswordField("Contraseña Actual", _isObscureOld, () {
                          setState(() {
                            _isObscureOld = !_isObscureOld;
                          });
                        }),
                        SizedBox(height: 15),
                        _buildPasswordField("Nueva Contraseña", _isObscureNew, () {
                          setState(() {
                            _isObscureNew = !_isObscureNew;
                          });
                        }),
                        SizedBox(height: 15),
                        _buildPasswordField("Confirmar Nueva Contraseña", _isObscureConfirm, () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
                          });
                        }),
                        SizedBox(height: screenSize.height * 0.05),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Acción para cambiar la contraseña
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Contraseña cambiada exitosamente")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF003F77),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              elevation: 4,
                              shadowColor: Colors.blueAccent.withOpacity(0.3),
                            ),
                            child: Text(
                              "Cambiar Contraseña",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para los campos de contraseña
  Widget _buildPasswordField(String label, bool isObscure, VoidCallback toggleVisibility) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),  // Fondo transparente para los campos de texto
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo no puede estar vacío";
        }
        return null;
      },
    );
  }
}
