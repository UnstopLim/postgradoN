// custom_appbar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(160);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent.withOpacity(0.1),
                  blurRadius: 100,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: CurvedAppBarClipper(),
          child: Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF400009), Color(0xFF002F53), Color(0xFF001E39)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo1.png', width: 130),
              ],
            ),
          ),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
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
    path.quadraticBezierTo(size.width / 2, size.height + 10, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
