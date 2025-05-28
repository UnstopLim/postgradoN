import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class Inscripccion extends StatefulWidget {
  const Inscripccion({super.key});

  @override
  State<Inscripccion> createState() => _InscripccionState();
}

class _InscripccionState extends State<Inscripccion> {
  String? _frontImagePath;
  String? _backImagePath;

  Future<void> _scanDocument(bool isFront) async {
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
        pageLimit: 1,
      ),
    );

    try {
      final result = await scanner.scanDocument();
      if (result.images.isNotEmpty) {
        setState(() {
          if (isFront) {
            _frontImagePath = result.images.first;
          } else {
            _backImagePath = result.images.first;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se capturó ninguna imagen.")),
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

  void _showFullScreenImage(String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: InteractiveViewer(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  bool get _canContinue => _frontImagePath != null && _backImagePath != null;

  Widget _buildScanCard({
    required String title,
    required VoidCallback onScan,
    required String? imagePath,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.indigo.shade100),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF003465), size: 28),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text("Escanear"),
            onPressed: onScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 14),
          if (imagePath != null)
            GestureDetector(
              onTap: () => _showFullScreenImage(imagePath),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text("Aún no escaneado", style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String stepNumber,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF003465),
            child: Text(stepNumber, style: const TextStyle(color: Colors.white)),
          ),
          title: Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003465))),
          iconColor: const Color(0xFF003465),
          collapsedIconColor: Colors.grey.shade600,
          childrenPadding: const EdgeInsets.symmetric(vertical: 10),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscripción")),
      body: ListView(
        children: [
          _buildExpansionTile(
            stepNumber: "1",
            title: "Escanear carnet",
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Para continuar con tu inscripción, por favor escanea ambos lados de tu carnet de identidad.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              _buildScanCard(
                title: "Anverso del carnet",
                onScan: () => _scanDocument(true),
                imagePath: _frontImagePath,
                icon: Icons.credit_card_rounded,
              ),
              _buildScanCard(
                title: "Reverso del carnet",
                onScan: () => _scanDocument(false),
                imagePath: _backImagePath,
                icon: Icons.flip_camera_android_rounded,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text("Siguiente"),
                  onPressed: _canContinue ? () => context.pushRoute(const Paso2Route()) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue ? const Color(0xFF003465) : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          _buildExpansionTile(
            stepNumber: "2",
            title: "Foto 4X4",
            children: [
              const ListTile(title: Text("Sube tus certificados")),
              const ListTile(title: Text("Documentos adicionales")),
              Image.asset("assets/edificio.png", fit: BoxFit.contain),
            ],
          ),
          _buildExpansionTile(
            stepNumber: "3",
            title: "Escanear Documentación académica",
            children: [
              const ListTile(title: Text("Sube el comprobante")),
              const ListTile(title: Text("Verifica tu pago")),
            ],
          ),
        ],
      ),
    );
  }
}
