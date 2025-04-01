import 'package:postgrado/Core/network/ApiClient.dart';
import 'package:postgrado/Feacture/CambiarPassword/domain/Models/CambioModel.dart';

class CambioRepository {
  final ApiClient apiClient;

  CambioRepository(this.apiClient);

  Future<Map<String, dynamic>> updatePassword({
    required String password,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final model = CambioModel(
      password: password,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    model.validate();

    return await apiClient.updatePassword(
      password: password,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}