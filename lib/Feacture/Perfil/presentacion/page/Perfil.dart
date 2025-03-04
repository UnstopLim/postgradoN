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
      backgroundColor: Colors.white,  // Fondo blanco para la pantalla
      body: Stack(
        children: [
          // Fondo del edificio con imagen más opaca
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,  // Opacidad para la imagen del logo del edificio
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.cover,  // Asegura que la imagen cubra toda la pantalla
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

                  // Avatar de perfil
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      color: Colors.white,  // Fondo opaco para el avatar
                      child: CircleAvatar(
                        radius: screenSize.width * 0.15,
                        backgroundImage: AssetImage('assets/editar-perfil.png'),
                      ),
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.05),

                  // Título de la sección
                  Text(
                    "Perfil de Usuario",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.03),

                  // Información del perfil de forma más profesional
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

  // Nueva forma de mostrar los datos de manera más moderna
  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color(0xFF004388), // Color de icono moderno
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
