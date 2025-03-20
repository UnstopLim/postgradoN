import 'package:flutter/material.dart';

class ErroConection extends StatefulWidget {
  @override
  State<ErroConection> createState() => _ErroConectionState();
}

class _ErroConectionState extends State<ErroConection> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 90,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 10),
          Text(
            "Sin conexión",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      content: Text(
        "No se pudo conectar a Internet.\nRevisa tu conexión e inténtalo de nuevo.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text("Aceptar"),
        ),
      ],
    );
  }
}
