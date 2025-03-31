
import 'package:postgrado/Core/network/ApiClient.dart';

import 'package:postgrado/Feacture/Perfil/domain/model/UserProfileModel.dart';

class PerfilRepository
{
  final ApiClient  apiClient;

  PerfilRepository(this.apiClient);

  Future<UserProfileModel?> getUserProfile()
  async
  {
    final responce = await apiClient.getUserProfile();
    if(responce!= null && responce.containsKey("data")){
      return UserProfileModel.fromJson(responce["data"]);
    }
    return null;
  }


}