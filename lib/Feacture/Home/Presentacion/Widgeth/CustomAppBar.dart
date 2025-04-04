import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: CurvedAppBarClipper(),
          child: Container(
            height: 165, // Ajustamos la altura a 180 para que coincida con preferredSize
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF3A0008), Color(0xFF00213A), Color(0xFF004C8F)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/LOGON.png', width: 130),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}

class CurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
