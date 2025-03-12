
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
        child: Icon(Icons.signal_wifi_statusbar_connected_no_internet_4,size: 85,color: Colors.grey,),
      ),
      content: Text("Lo siento no tiene conexion a internet",style: TextStyle(fontSize: 17),),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
       child: Text("Aseptar",style: TextStyle(fontSize: 17,color: Color(
           0xFF00244A)),))
      ],
    );
  }
}
