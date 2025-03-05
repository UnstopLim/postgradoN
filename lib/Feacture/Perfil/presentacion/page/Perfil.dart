import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/CustomAppBar.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/drawer.dart';

@RoutePage()
class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.cover,
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
                  Image.asset('assets/editar-perfil.png', width: 130),
                  SizedBox(height: screenSize.height * 0.05),
                  Text(
                    "Perfil de Usuario",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildInfoItem(Icons.perm_identity, "C.I.", "12345678"),
                  _buildInfoItem(Icons.person, "Nombre", "Juan Carlos"),
                  _buildInfoItem(Icons.person_outline, "Apellidos", "Pérez López"),
                  _buildInfoItem(Icons.phone, "Celular", "+591 77788899"),
                  _buildInfoItem(Icons.email, "Correo", "juan.perez@email.com"),

                  SizedBox(height: screenSize.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color(0xFF004388),
            size: 30,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54, // Título de color más suave
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // Valor más destacado
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
