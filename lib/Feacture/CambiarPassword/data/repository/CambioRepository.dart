import 'package:postgrado/Core/network/ApiClient.dart';

class CambioRepository
{
  final ApiClient apiClient;
  CambioRepository(this.apiClient);

  Future<Map<String,dynamic>?> UpdatePassword(String password,String NewPassword,String NewPassword2)
  async
  {
     return await apiClient.UpdatePassword(password, NewPassword, NewPassword2);
  }

}