import 'package:flutter/material.dart';

class Recuperar extends StatefulWidget {
  const Recuperar({super.key});

  @override
  State<Recuperar> createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<Recuperar> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 Aquí se mantiene el AppBar **exactamente igual al de Home**
      appBar: _buildAppBar(),

      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔒 Icono de seguridad
            Icon(Icons.lock_reset_rounded, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 15),

            // 📢 Título principal
            Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // 📝 Descripción corta
            Text(
              "Ingresa tu correo y te enviaremos un enlace para recuperar tu cuenta.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // 📩 Campo de correo electrónico
            _buildTextField("Correo Electrónico", Icons.email, _emailController),

            const SizedBox(height: 20),

            // 🔘 Botón de recuperar contraseña
            ElevatedButton(
              onPressed: () {
                _enviarRecuperacion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006FD8),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Enviar enlace", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),

            const SizedBox(height: 20),

            // 🔙 Opción de regresar al login
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Regresar al inicio de sesión",
                style: TextStyle(fontSize: 16, color: Color(0xFF006FD8), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Se mantiene el **mismo AppBar de Home**
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Recuperar Contraseña", // Puedes cambiar el título si es necesario
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Color(0xFF006FD8), // El mismo color de Home
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      // 🔥 Aquí puedes agregar otros estilos si tu Home tenía algo más
    );
  }

  // 📌 Método para construir un campo de texto
  Widget _buildTextField(String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // 📩 Simulación del envío de correo
  void _enviarRecuperacion() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Se ha enviado un enlace a $email"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ingresa un correo válido"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
