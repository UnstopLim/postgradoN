
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/drawer.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/AlertDialog.dart'; // Importa el paquete

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
      //DialogExample();

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
                const SizedBox(height: 20), // Espaciado para evitar la barra de estado
                Image.asset(
                  'assets/logo1.png', // Asegúrate de colocar tu logo en assets
                  height: 115,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBuilder: (context, tabsRouter) {
        return CurvedNavigationBar(
          index: tabsRouter.activeIndex,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.security_outlined, size: 30, color: Color(0xFF004B91)),
            Icon(Icons.person, size: 30, color: Color(0xFF004B91)),
            Icon(Icons.password_outlined, size: 30, color: Color(0xFF004B91)),
            Icon(Icons.exit_to_app, size: 30, color: Color(0xFF004B91)),
          ],
          color: Color(0xFFE3E3E3), // Color del fondo de la barra
          buttonBackgroundColor: Color(0xFFDFDFDF), // Color del botón activo
          backgroundColor: Colors.white, // Fondo de la barra
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) => _onItemTapped(index, tabsRouter),

        );
      },
    );
  }
}

// Clipper para la AppBar curva
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size)
  {
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
