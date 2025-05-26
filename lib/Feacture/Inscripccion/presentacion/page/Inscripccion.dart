import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';



import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class Inscripccion extends StatefulWidget {
  const Inscripccion({super.key});

  @override
  State<Inscripccion> createState() => _InscripccionState();
}

class _InscripccionState extends State<Inscripccion> {
  String? _imagePath;

  Future<void> _scanDocument()
  async
  {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permiso de cámara denegado")),
      );
      return;
    }

    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        documentFormat: DocumentFormat.jpeg,
        mode: ScannerMode.filter,
        pageLimit: 2,
        //isGalleryImport: true,
      ),
    );

    try {
      final result = await scanner.scanDocument();
      // Lanza la interfaz para escanear el documento

      if (result.images.isNotEmpty) {
        setState(() {
          _imagePath = result.images.first;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se capturó ninguna imagen actualizate.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al escanear: $e")),
      );
    } finally {
      scanner.close();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscripción"),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            leading: CircleAvatar(
              radius: 12,
              child: Text("1"),
            ),
            title: Text("Escanear carnet"),
            children: [
              ElevatedButton(
                onPressed: _scanDocument,
                child: const Text("Escanear Carnet"),
              ),
              const SizedBox(height: 20),

              if (_imagePath != null)

                Column(
                  children: [
                    const Text("Imagen escaneada:"),
                    const SizedBox(height: 10),
                    Image.file(
                      File(_imagePath!),
                      height: 300,
                    ),
                  ],
                )
            ],
          ),
          ExpansionTile(
            leading: CircleAvatar(
              radius: 12,
              child: Text("2"),
            ),
            title: Text("Foto 4X4"),
            children: [
              ListTile(title: Text("Sube tus certificados")),
              ListTile(title: Text("Documentos adicionales")),
              Image.asset("assets/edificio.png", fit: BoxFit.contain)
            ],
          ),
          ExpansionTile(
            leading: CircleAvatar(
              radius: 12,
              child: Text("3"),
            ),
            title: Text("Escanear Documentacion academica "),
            children: [
              ListTile(title: Text("Sube el comprobante")),
              ListTile(title: Text("Verifica tu pago")),
            ],
          ),
        ],
      ),
    );
  }

}
