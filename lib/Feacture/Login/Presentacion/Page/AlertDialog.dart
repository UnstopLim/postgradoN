
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auto_route/auto_route.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Estado/ApiClientRiberput.dart';

class LogoutDialog extends StatelessWidget
{
  final WidgetRef ref;

  LogoutDialog({required this.ref});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Icon(Icons.exit_to_app_outlined,color: Color(0xff55595e),size: 85,),
          SizedBox(height: 20),
          Text("Serrar seccion",style: TextStyle(fontSize: 29,fontWeight: FontWeight.w500),)
        ],
      ),
      content:  Text("¿Estás seguro de que quieres cerrar sesión?",style: TextStyle(fontSize: 17),),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar",style: TextStyle(fontSize: 17,color: Colors.blue.shade900,fontWeight: FontWeight.bold),),
        ),
        TextButton(
          onPressed: ()
          async
          {
            await ref.read(authProvider.notifier).logout();
            context.router.replace(Login());
          },
          child: Text("Sí",style: TextStyle(fontSize: 17,color: Colors.blue.shade900,fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}
