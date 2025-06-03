import 'package:postgrado/Feacture/Inscripccion/data/repository/InscripcionRepository.dart';

class UploadImagesUseCase {
  final InscripcionRepository inscripcionRepository;

  UploadImagesUseCase(this.inscripcionRepository);

  Future<Map<String, dynamic>?> execute({
    required String frontImagePath,
    required String backImagePath,
    required String frontTituloPath,
    required String backTituloPath,
  })
  async
  {
        try {
          // Validar que todas las imágenes existan
          if (frontImagePath.isEmpty ||
              backImagePath.isEmpty ||
              frontTituloPath.isEmpty ||
              backTituloPath.isEmpty) {
            throw "Todas las imágenes son requeridas";
          }

          final result = await inscripcionRepository.uploadInscripcionImages(
            frontImagePath: frontImagePath,
            backImagePath: backImagePath,
            frontTituloPath: frontTituloPath,
            backTituloPath: backTituloPath,
          );

          return result;
        } catch (e) {
          print("Error en UploadImagesUseCase: $e");
          rethrow;
        }
  }
}