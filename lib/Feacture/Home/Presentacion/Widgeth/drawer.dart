import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005EBC), Color(0xFF002244), Color(0xFF440006)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                BounceInLeft(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'),
                  ),
                ),
                SizedBox(width: 15),
                FadeIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Estudiante",
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Limber mamani",
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [

                DrawerItem(icon: Icons.person, text: "Perfil",onTab: (){ context.router.push(Perfil()); }),
                DrawerItem(icon: Icons.dashboard, text: "Token",onTab: (){ context.router.push(Home()); }),
                DrawerItem(icon: Icons.settings, text: "Cambiar la contraseña",onTab: (){ context.router.push(Cambio()); }),
                DrawerItem(icon: Icons.help_outline, text: "Ayuda",onTab: (){ context.router.push(Perfil()); }),
                Divider(),
                DrawerItem(icon: Icons.logout, text: "Cerrar sesión",onTab: (){ context.router.push(Login()); }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTab;

  DrawerItem({required this.icon, required this.text,required this.onTab});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900, size: 28),
      title: Text(text,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () { onTab();},
    );
  }
}
