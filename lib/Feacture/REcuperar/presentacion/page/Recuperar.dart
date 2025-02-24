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
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
         child:  Padding(
           padding: const EdgeInsets.all(20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Icon(Icons.lock_reset_rounded, size: 100, color: Color(0xFF0056A6)),
               const SizedBox(height: 15),
               Text(
                 "¿Olvidaste tu contraseña?",
                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
               ),
               const SizedBox(height: 10),

               Text(
                 "Ingresa tu correo y te enviaremos un enlace para recuperar tu cuenta.",
                 textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 16, color: Colors.grey[700]),
               ),
               const SizedBox(height: 20),
               TextField(
                 controller: num1,
                 obscureText: true,
                 decoration: InputDecoration(
                   labelText: "Correo electronico",
                   border: OutlineInputBorder(),
                   filled: true,
                   fillColor: Colors.white.withOpacity(0.2),
                   focusedBorder: OutlineInputBorder(
                     borderSide: BorderSide(color: Colors.black, width: 2.0), // Borde negro cuando está enfocado
                     borderRadius: BorderRadius.circular(52),
                   ),
                 ),
               ),
               const SizedBox(height: 20),
               ElevatedButton(
                 onPressed: () {
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Color(0xFF0056A8),
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
                   style: TextStyle(fontSize: 16, color: Color(0xFF005AAA), fontWeight: FontWeight.bold),
                 ),
               ),
             ],
           ),
         ),
      )
    );
  }
}











