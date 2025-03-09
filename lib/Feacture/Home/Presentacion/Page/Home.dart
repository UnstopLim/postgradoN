import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/drawer.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/AlertDialog.dart';

@RoutePage()
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, TabsRouter tabsRouter) {
    if (index == 3) {
      context.router.replaceAll([const Login()]);
    } else {
      setState(() {
        _selectedIndex = index;
        tabsRouter.setActiveIndex(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeBody(),
        Perfil(),
        Cambio(),
      ],
      drawer: CustomDrawer(),
      appBarBuilder: (context, tabsRouter) => PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A0008), Color(0xFF00213A), Color(0xFF004C8F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logo1.png',
                  height: 115,
                ),
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBuilder: (context, tabsRouter) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              /// 🔹 **Sombra curvada con BoxShadow**
              Positioned(
                top: -20, // Ajuste para que se vea bien la sombra
                left: 0,
                right: 0,
                child: Container(
                  height: 80, // Ajustar para que la sombra coincida con la barra
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Fondo transparente para la sombra
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Color de la sombra
                        blurRadius: 20, // Difuminado de la sombra
                        spreadRadius: 5, // Extensión de la sombra
                        offset: Offset(0, 10), // Posición de la sombra hacia abajo
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50), // 🔹 Sombra curvada
                    ),
                  ),
                ),
              ),

              /// 🔹 **CurvedNavigationBar (sin cambios)**
              CurvedNavigationBar(
                index: tabsRouter.activeIndex,
                height: 60.0,
                items: <Widget>[
                  Icon(Icons.security_outlined, size: 30, color: Color(
                      0xFF3E0009)),
                  Icon(Icons.person, size: 30, color: Color(0xFF3E0009)),
                  Icon(Icons.password_outlined, size: 30, color: Color(
                      0xFF3E0009)),
                  Icon(Icons.exit_to_app, size: 30, color: Color(0xFF3E0009)),
                ],
                color: Color(0xFFFFFFFF),
                buttonBackgroundColor: Color(0xFFFFFFFF),
                backgroundColor: Colors.transparent, // 🔹 Fondo transparente
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 300),
                onTap: (index) => _onItemTapped(index, tabsRouter),
              ),
            ],
          );
        }

    );
  }
}

/// 🔹 **Clase para dibujar la sombra curva**
class CurvedShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.2)  // Color de la sombra
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);  // Desenfoque de sombra

    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height - 40, size.width, size.height);
    path.lineTo(size.width, size.height + 20);
    path.lineTo(0, size.height + 20);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 🔹 Clipper para la AppBar curva (esto sigue igual)
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
