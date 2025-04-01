import 'package:postgrado/Feacture/CambiarPassword/data/repository/CambioRepository.dart';

class CambioUseCase {
  final CambioRepository cambioRepository;

  CambioUseCase(this.cambioRepository);

  Future<Map<String, dynamic>> execute({
    required String password,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await cambioRepository.updatePassword(
      password: password,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}