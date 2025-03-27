

import 'package:postgrado/Core/network/ApiClient.dart';
import 'package:postgrado/Feacture/Home/domain/models/token_models.dart';

class tokenRepository
{
  final ApiClient apiClient;
   tokenRepository(this.apiClient);
   Future<TokenModels?> getTokenUser()
  async
  {
    final responce = await apiClient.getTokenUser();
    if(responce!=null && responce.containsKey("data"))
      {
         return TokenModels.fromJson(responce["data"]);
      }
    return null;
  }
}