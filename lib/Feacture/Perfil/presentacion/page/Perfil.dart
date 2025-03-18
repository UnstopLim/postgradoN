import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Feacture/Perfil/presentacion/data/estado/PerfilProvider.dart';

@RoutePage()
class Perfil extends ConsumerWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilAsync = ref.watch(perfilProvider);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset("assets/edificio.png", fit: BoxFit.contain),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              child: perfilAsync.when(
                data: (perfil) {
                  if (perfil == null) {
                    return Center(child: Text("Error al cargar los datos."));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenSize.height * 0.02),
                      Image.asset('assets/editar-perfil.png', width: 120),
                      SizedBox(height: screenSize.height * 0.05),
                      Text(
                        "Datos Personales",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      _buildInfoItem(Icons.perm_identity, "Nombre Usuario", perfil.nombre_usuario),
                      _buildInfoItem(Icons.person, "Nombre", perfil.persona.nombre),
                      _buildInfoItem(Icons.person_outline, "Apellidos", "${perfil.persona.paterno} ${perfil.persona.materno}"),
                      _buildInfoItem(Icons.phone, "Celular", perfil.persona.celular),
                      _buildInfoItem(Icons.email, "Correo", perfil.persona.correo),
                      SizedBox(height: screenSize.height * 0.1),
                    ],
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text("Error: $error")),
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
          Icon(icon, color: Color(0xFF004388), size: 30),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
                SizedBox(height: 5),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

