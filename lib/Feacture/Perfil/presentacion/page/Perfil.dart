
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/CustomAppBar.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/drawer.dart';


class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Clave para controlar el Drawer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asociamos la clave al Scaffold
      appBar: CustomAppBar(),
      drawer: CustomDrawer(), // Drawer personalizado
      backgroundColor: Color(0xFFDDDDDD),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar del usuario
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/profile.png'), // Imagen del usuario
              ),
              const SizedBox(height: 15),

              // Nombre del usuario
              Text(
                "Juan Carlos Pérez",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Ingeniero de Sistemas",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Tarjetas de información personal
              _buildInfoCard(Icons.perm_identity, "CI", "12345678"),
              _buildInfoCard(Icons.person, "Nombre", "Juan Carlos"),
              _buildInfoCard(Icons.person_outline, "Apellidos", "Pérez López"),
              _buildInfoCard(Icons.phone, "Celular", "+591 77788899"),
              _buildInfoCard(Icons.email, "Correo", "juan.perez@email.com"),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para mostrar información en tarjetas elegantes
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF006FD8), size: 28),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }
}
