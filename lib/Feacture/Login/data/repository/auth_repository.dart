
import 'package:postgrado/Core/network/ApiClient.dart';

class auth_repository{
   final ApiClient apiClient;

   auth_repository(this.apiClient);

   Future<Map<String,dynamic >?> login(String username,String password)
   async
   {
       return await apiClient.login(username, password);
   }



}