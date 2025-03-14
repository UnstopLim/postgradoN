
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErroConection extends StatefulWidget {
  @override
  State<ErroConection> createState() => _ErroConectionState();
}

class _ErroConectionState extends State<ErroConection> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Icon(Icons.signal_wifi_statusbar_connected_no_internet_4,size: 90,color: Colors.grey),
      ),
      backgroundColor: Color(0xFFFFFFFF),
      content: Text("Algo salió mal.  :(  Por favor, revisa tu conexión a Internet e inténtalo de nuevo.",style: TextStyle(fontSize: 17,color: Color(
          0xFF400000) ),),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
       child: Text("Aseptar",style: TextStyle(fontSize: 19,color: Color(
           0xFF450000),fontWeight: FontWeight.bold),))
      ],
    );
  }
}
