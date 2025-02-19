import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Fondo azul con el logo
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.shade900],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.school, // Aquí puedes poner tu logo
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              // Formulario flotante
              Positioned(
                top: screenHeight * 0.22, // Ajuste para que sobresalga
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Evita que se expanda innecesariamente
                    children: [
                      Text(
                        'Bienvenidoss',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Usuario",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.android),
              title: const Text("Perfil"),
              onTap: () {
                context.router.push(Login());
                Navigator.pop(context);

              },
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text("Token"),
              onTap: () {
                context.router.push(Curs());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_tree_rounded),
              title: Text("Cursos"),
              onTap: () {
                context.router.push(Curs());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: Text("Notifications"),
              onTap: () {
                context.router.push(ForgotyouPass());
                Navigator.pop(context);
              },
            )
          ],
        ),

      ),


    );

  }

}