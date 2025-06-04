import 'package:postgrado/Feacture/Inscripccion/data/repository/InscripcionRepository.dart';

class UploadImagesUseCase {
  final InscripcionRepository inscripcionRepository;

  UploadImagesUseCase(this.inscripcionRepository);

  // MÉTODO ACTUALIZADO - Ahora incluye expiryDate
  Future<Map<String, dynamic>?> execute({
    required String frontImagePath,
    required String backImagePath,
    required String frontTituloPath,
    required String backTituloPath,
    required String expiryDate, // NUEVO PARÁMETRO
  }) async {
    try {
      // Validar que todas las imágenes existan y la fecha
      if (frontImagePath.isEmpty ||
          backImagePath.isEmpty ||
          frontTituloPath.isEmpty ||
          backTituloPath.isEmpty ||
          expiryDate.isEmpty) { // VALIDAR FECHA
        throw "Todas las imágenes y la fecha de vencimiento son requeridas";
      }

      final result = await inscripcionRepository.uploadInscripcionImages(
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
        frontTituloPath: frontTituloPath,
        backTituloPath: backTituloPath,
        expiryDate: expiryDate, // PASAR LA FECHA
      );

      return result;
    } catch (e) {
      print("Error en UploadImagesUseCase: $e");
      rethrow;
    }
  }
}
