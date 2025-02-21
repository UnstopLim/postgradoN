import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';


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
                colors: [Color(0xFF005EBC), Color(0xFF002244)],
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
                SlideInLeft(child: DrawerItem(icon: Icons.dashboard, text: "Dashboard")),
                SlideInLeft(child: DrawerItem(icon: Icons.person, text: "Perfil")),
                SlideInLeft(child: DrawerItem(icon: Icons.settings, text: "Configuración")),
                SlideInLeft(child: DrawerItem(icon: Icons.help_outline, text: "Ayuda")),
                Divider(),
                SlideInLeft(child: DrawerItem(icon: Icons.logout, text: "Cerrar sesión")),
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

  DrawerItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ZoomIn(child: Icon(icon, color: Colors.blue.shade900, size: 28)),
      title: Text(text,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 28);
    path.quadraticBezierTo(size.width / 2, size.height + 28, size.width, size.height - 28);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}


class YellowHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 34);
    path.quadraticBezierTo(size.width / 2, size.height + 25, size.width, size.height - 35);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}


