import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:postgrado/Feacture/Inscripccion/presentacion/state/InscripccionProvider.dart';
import 'package:intl/intl.dart';

@RoutePage()
class Inscripccion extends ConsumerStatefulWidget {
  const Inscripccion({super.key});

  @override
  ConsumerState<Inscripccion> createState() => _InscripccionState();
}

class _InscripccionState extends ConsumerState<Inscripccion> {
  String? _frontImagePath;
  String? _backImagePath;
  String? _fromTituloImage;
  String? _back_tituloImage;
  DateTime? _selectedExpiryDate; // Nueva variable para fecha de vencimiento

  Future<void> SnackVarVar(String valor) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${valor}")),
    );
  }

  Future<void> _scanDocument(int num) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      SnackVarVar("Permiso de cámara denegado");
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
          switch (num) {
            case 1:
              _frontImagePath = result.images.first;
              break;
            case 2:
              _backImagePath = result.images.first;
              break;
            case 3:
              _fromTituloImage = result.images.first;
              break;
            case 4:
              _back_tituloImage = result.images.first;
              break;
          }
        });
      } else {
        SnackVarVar("No se capturó ninguna imagen.");
      }
    } catch (e) {
      SnackVarVar("Error al escanear: $e");
    } finally {
      scanner.close();
    }
  }


  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 365)), // Un año desde hoy
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 20)), // 20 años máximo
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF003465),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedExpiryDate) {
      setState(() {
        _selectedExpiryDate = picked;
      });
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


  bool get _canContinue => _frontImagePath != null && _backImagePath != null && _fromTituloImage != null && _back_tituloImage != null && _selectedExpiryDate != null;


  Future<void> _uploadImages() async
  {
    if (!_canContinue) {
      SnackVarVar("Por favor, escanea todas las imágenes y selecciona la fecha de vencimiento");
      return;
    }
    try {

      String expiryDateString = DateFormat('yyyy-MM-dd').format(_selectedExpiryDate!);

      await ref.read(inscripcionProvider.notifier).uploadImages(
        frontImagePath: _frontImagePath!,
        backImagePath: _backImagePath!,
        frontTituloPath: _fromTituloImage!,
        backTituloPath: _back_tituloImage!,
        expiryDate: expiryDateString,
      );
    } catch (e) {
      SnackVarVar("Error al subir imágenes: $e");
    }
  }

  // Función para obtener márgenes responsivos
  EdgeInsets _getResponsiveMargin() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else if (screenWidth < 400) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  // Función para obtener padding responsivo
  EdgeInsets _getResponsivePadding() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.all(12);
    } else if (screenWidth < 400) {
      return const EdgeInsets.all(14);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  // Función para obtener tamaño de fuente responsivo
  double _getResponsiveFontSize(double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize - 2;
    } else if (screenWidth < 400) {
      return baseSize - 1;
    } else {
      return baseSize;
    }
  }

  // Función para obtener altura de imagen responsiva
  double _getResponsiveImageHeight() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenHeight < 700 || screenWidth < 360) {
      return 150;
    } else if (screenHeight < 800) {
      return 180;
    } else {
      return 200;
    }
  }

  Widget _buildScanCard({required String title, required VoidCallback onScan, required String? imagePath, required IconData icon,})
  {
    return Container(
      margin: _getResponsiveMargin(),
      padding: _getResponsivePadding(),
      decoration: BoxDecoration(color: Color(0xffffffff), border: Border.all(color: Color(0xff00345c)),borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),],),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF003465), size: _getResponsiveFontSize(28)),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8 : 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 8 : 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.camera_alt_outlined,
              size: _getResponsiveFontSize(20),
            ),
            label: Text("Escanear", style: TextStyle(fontSize: _getResponsiveFontSize(16)),),
            onPressed: onScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 10 : 14),
          if (imagePath != null)
            GestureDetector(
              onTap: () => _showFullScreenImage(imagePath),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  height: _getResponsiveImageHeight(),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: _getResponsiveImageHeight(),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                "Aún no escaneado",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: _getResponsiveFontSize(14),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildExpiryDateCard() {
    return Container(
      margin: _getResponsiveMargin(),
      padding: _getResponsivePadding(),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xff01264c)),
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
              Icon(Icons.calendar_today, color: const Color(0xFF003465), size: _getResponsiveFontSize(28)),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8 : 10),
              Expanded(
                child: Text(
                  "Fecha de vencimiento del carnet",
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 8 : 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.date_range_outlined,
              size: _getResponsiveFontSize(20),
            ),
            label: Text(
              "Seleccionar fecha",
              style: TextStyle(fontSize: _getResponsiveFontSize(16)),
            ),
            onPressed: _selectExpiryDate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width < 360 ? 10 : 12,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width < 360 ? 10 : 14),
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width < 360 ? 12 : 16),
            decoration: BoxDecoration(
              color: _selectedExpiryDate != null ? Colors.green.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _selectedExpiryDate != null ? Colors.green.shade300 : Colors.grey.shade300
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedExpiryDate != null ? Icons.check_circle : Icons.schedule,
                  color: _selectedExpiryDate != null ? Colors.green : Colors.grey,
                  size: _getResponsiveFontSize(20),
                ),
                SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8 : 12),
                Expanded(
                  child: Text(
                    _selectedExpiryDate != null
                        ? "Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedExpiryDate!)}"
                        : "Aún no seleccionada",
                    style: TextStyle(
                      color: _selectedExpiryDate != null ? Colors.green.shade700 : Colors.grey,
                      fontSize: _getResponsiveFontSize(16),
                      fontWeight: _selectedExpiryDate != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({required String stepNumber, required String title, required List<Widget> children,})
  {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth < 360 ? 12 : 16, vertical: screenWidth < 360 ? 6 : 8,),
      decoration: BoxDecoration(color: Colors.transparent,
        border: Border.all(color: Color(0xff001d3a)),
        borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.white, blurRadius: 10, offset: Offset(0, 6)),],),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent,),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor:  const Color(0xFFD3A203),
            radius: screenWidth < 360 ? 18 : 20,
            child: Text(stepNumber, style: TextStyle(color: Colors.black, fontSize: _getResponsiveFontSize(16),),),
          ),
          title: Text(title, style: TextStyle(fontSize: _getResponsiveFontSize(18), fontWeight: FontWeight.bold, color: Color(0xFF000407),),),
          iconColor: const Color(0xFF0081FF),
          collapsedIconColor: Colors.grey.shade600,
          childrenPadding: EdgeInsets.symmetric(vertical: screenWidth < 360 ? 8 : 10,),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar el estado de la inscripción
    ref.listen<InscripcionState>(inscripcionProvider, (previous, next) {
      if (next.isSuccess) {
        SnackVarVar("¡Imágenes enviadas exitosamente!");
      } else if (next.error != null) {
        SnackVarVar("Error: ${next.error}");
      }
    });

    final inscripcionState = ref.watch(inscripcionProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(child: Opacity(opacity: 0.2, child: Image.asset("assets/edificio.png", fit: BoxFit.contain),),),
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 360 ? 4 : 0,
            ),
            children: [
              Center(child: Text("Inscripccion",style: TextStyle(fontSize:  _getResponsiveFontSize(20),height: 3),),),

              _buildExpansionTile(
                stepNumber: "1",
                title: "Escanear carnet",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 16.0 : 20.0,
                    ),
                    child: Text(
                      "Para continuar con tu inscripción, por favor escanea ambos lados de tu carnet de identidad y selecciona la fecha de vencimiento.",
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(16),
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth < 360 ? 16 : 20),
                  _buildScanCard(
                    title: "Anverso del carnet",
                    onScan: () => _scanDocument(1),
                    imagePath: _frontImagePath,
                    icon: Icons.credit_card_rounded,
                  ),
                  _buildScanCard(
                    title: "Reverso del carnet",
                    onScan: () => _scanDocument(2),
                    imagePath: _backImagePath,
                    icon: Icons.flip_camera_android_rounded,
                  ),
                  _buildExpiryDateCard(), // Nuevo card de fecha
                  SizedBox(height: screenWidth < 360 ? 20 : 30),
                ],
              ),
              _buildExpansionTile(
                stepNumber: "2",
                title: "Foto 4X4",
                children: [
                  ListTile(
                    title: Text(
                      "Sube tus certificados",
                      style: TextStyle(fontSize: _getResponsiveFontSize(16)),
                    ),
                    dense: screenWidth < 360,
                  ),
                  ListTile(
                    title: Text(
                      "Documentos adicionales",
                      style: TextStyle(fontSize: _getResponsiveFontSize(16)),
                    ),
                    dense: screenWidth < 360,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 12 : 16,
                    ),
                    child: Image.asset(
                      "assets/edificio.png",
                      fit: BoxFit.contain,
                      height: screenHeight < 700 ? 120 : 150,
                    ),
                  ),
                ],
              ),
              _buildExpansionTile(
                stepNumber: "3",
                title: "Escanear Documentación académica",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 16.0 : 20.0,
                    ),
                    child: Text(
                      "Por favor escanea ambos lados de documentacion academica.",
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(16),
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth < 360 ? 16 : 20),
                  _buildScanCard(
                    title: "Anverso del Titulo",
                    onScan: () => _scanDocument(3),
                    imagePath: _fromTituloImage,
                    icon: Icons.credit_card_rounded,
                  ),
                  _buildScanCard(
                    title: "Reverso del Titulo",
                    onScan: () => _scanDocument(4),
                    imagePath: _back_tituloImage,
                    icon: Icons.flip_camera_android_rounded,
                  ),
                  SizedBox(height: screenWidth < 360 ? 20 : 30),
                ],
              ),
              SizedBox(height: screenWidth < 360 ? 20 : 30),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 360 ? 16.0 : 20.0,
                ),
                child: ElevatedButton.icon(
                  icon: inscripcionState.isLoading
                      ? SizedBox(
                    width: screenWidth < 360 ? 14 : 16,
                    height: screenWidth < 360 ? 14 : 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Icon(
                    Icons.arrow_forward_rounded,
                    size: _getResponsiveFontSize(20),
                  ),
                  label: Text(
                    inscripcionState.isLoading ? "Enviando..." : "Siguiente",
                    style: TextStyle(fontSize: _getResponsiveFontSize(16)),
                  ),
                  onPressed: (_canContinue && !inscripcionState.isLoading)
                      ? _uploadImages
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_canContinue && !inscripcionState.isLoading)
                        ? const Color(0xFF003465)
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth < 360 ? 14 : 16,
                    ),
                    textStyle: TextStyle(fontSize: _getResponsiveFontSize(16)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              SizedBox(height: screenWidth < 360 ? 20 : 30)
            ],
          ),
        ],
      ),
    );
  }
}