import 'package:postgrado/Core/network/ApiClient.dart';

class InscripcionRepository {
  final ApiClient apiClient;

  InscripcionRepository(this.apiClient);

  Future<Map<String, dynamic>?> uploadInscripcionImages({
    required String frontImagePath,
    required String backImagePath,
    required String frontTituloPath,
    required String backTituloPath,
  }) async {
    try {
      final response = await apiClient.uploadImages(
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
        frontTituloPath: frontTituloPath,
        backTituloPath: backTituloPath,
      );
      return response;
    } catch (e) {
      print("Error en InscripcionRepository: $e");
      rethrow;
    }
  }
}