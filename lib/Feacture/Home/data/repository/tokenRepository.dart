

import 'package:postgrado/Core/network/ApiClient.dart';
import 'package:postgrado/Feacture/Home/domain/models/token_models.dart';

class tokenRepository
{
  final ApiClient apiClient;
   tokenRepository(this.apiClient);

   Future<Data?> getTokenUser()
  async
  {
    final response = await apiClient.getTokenUser();
    print("Respuesta completa del token: $response"); // 👈 Agregar esto

    if (response != null && response.containsKey("data")) {
      print("Contenido de 'data': ${response['data']}"); // 👈 Agregar esto
      return Data.fromJson(response['data']); // 👈 Aquí debe ser response['data']
    }
    return null;
  }
}