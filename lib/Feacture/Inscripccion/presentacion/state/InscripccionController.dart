// inscripcion_ui_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

// Estado para la UI
class InscripcionUIState {
  final String? frontImagePath;
  final String? backImagePath;
  final String? fromTituloImage;
  final String? backTituloImage;
  final DateTime? selectedExpiryDate;
  final bool isScanning;

  const InscripcionUIState({
    this.frontImagePath,
    this.backImagePath,
    this.fromTituloImage,
    this.backTituloImage,
    this.selectedExpiryDate,
    this.isScanning = false,
  });

  InscripcionUIState copyWith({
    String? frontImagePath,
    String? backImagePath,
    String? fromTituloImage,
    String? backTituloImage,
    DateTime? selectedExpiryDate,
    bool? isScanning,
  }) {
    return InscripcionUIState(
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      fromTituloImage: fromTituloImage ?? this.fromTituloImage,
      backTituloImage: backTituloImage ?? this.backTituloImage,
      selectedExpiryDate: selectedExpiryDate ?? this.selectedExpiryDate,
      isScanning: isScanning ?? this.isScanning,
    );
  }

  bool get canContinue =>
      frontImagePath != null &&
          backImagePath != null &&
          fromTituloImage != null &&
          backTituloImage != null &&
          selectedExpiryDate != null;

  String get formattedExpiryDate =>
      selectedExpiryDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedExpiryDate!)
          : '';

  String get displayExpiryDate =>
      selectedExpiryDate != null
          ? DateFormat('dd/MM/yyyy').format(selectedExpiryDate!)
          : '';
}

// Notifier para manejar la lógica de UI
class InscripcionUINotifier extends StateNotifier<InscripcionUIState> {
  InscripcionUINotifier() : super(const InscripcionUIState());

  // Función para mostrar SnackBar (necesita contexto, se pasa desde el widget)
  Future<void> showSnackBar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Lógica para escanear documentos
  Future<void> scanDocument(int documentType, BuildContext context) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      await showSnackBar(context, "Permiso de cámara denegado");
      return;
    }

    state = state.copyWith(isScanning: true);

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
        final imagePath = result.images.first;

        switch (documentType) {
          case 1:
            state = state.copyWith(frontImagePath: imagePath);
            break;
          case 2:
            state = state.copyWith(backImagePath: imagePath);
            break;
          case 3:
            state = state.copyWith(fromTituloImage: imagePath);
            break;
          case 4:
            state = state.copyWith(backTituloImage: imagePath);
            break;
        }
      } else {
        await showSnackBar(context, "No se capturó ninguna imagen.");
      }
    } catch (e) {
      await showSnackBar(context, "Error al escanear: $e");
    } finally {
      scanner.close();
      state = state.copyWith(isScanning: false);
    }
  }

  // Lógica para seleccionar fecha
  Future<void> selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 20)),
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

    if (picked != null && picked != state.selectedExpiryDate) {
      state = state.copyWith(selectedExpiryDate: picked);
    }
  }

  // Mostrar imagen en pantalla completa
  void showFullScreenImage(BuildContext context, String imagePath) {
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
}

// Provider para la UI
final inscripcionUIProvider = StateNotifierProvider<InscripcionUINotifier, InscripcionUIState>((ref) {
  return InscripcionUINotifier();
});

// Clase para manejar la lógica de responsive design
class ResponsiveHelper {
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else if (screenWidth < 400) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.all(12);
    } else if (screenWidth < 400) {
      return const EdgeInsets.all(14);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize - 2;
    } else if (screenWidth < 400) {
      return baseSize - 1;
    } else {
      return baseSize;
    }
  }

  static double getResponsiveImageHeight(BuildContext context) {
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
}