
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient
{
    //Url principal
    final Dio dio;
    final FlutterSecureStorage secureStorage;
    ApiClient({Dio? dio,FlutterSecureStorage? secureStorage})
        :dio = dio ?? Dio(BaseOptions(baseUrl: "https://api-preinscripcion.posgradoupea.edu.bo/api/v1")),
    secureStorage = secureStorage ?? const FlutterSecureStorage();
    //Enpoint de login
    Future<Map<String,dynamic>?> login(String username,String password)
    async
    {
        try
        {
           final responce = await dio.post("/auth",data: {
               "username" : username,
               "password": password
           });
           return responce.data;
        }on DioException catch(e)
        {
            print("error en login : ${e.response?.data ?? e.message}");
            return  null;
        }
    }
    //Enpoint de perfil
    Future<Map<String,dynamic>?> getUserProfile() async
    {
        try
        {
           final token = await secureStorage.read(key: 'auth_token');
           if(token==null)
               {
                   print("El toke es null ");
                   return null;
               }
           final responce = await dio.get("/usuario/my-data",options: Options(headers: {"Authorization" : "Bearer $token"}));
            print("respueta del perfil del get ${responce.data}");
           return responce.data;
        } on DioException catch(e)
        {
            print("Error al obtener el perfil: ${e.response?.data ??e.message } " );
            return null;
        }
    }
    // enpoint gettoken
    Future<Map<String,dynamic>?> getTokenUser() async
    {
      try
      {
         final token = await secureStorage.read(key: 'auth_token');
         if(token ==null)
         {
             print("El token es null");
             return null;
         }
         final responce= await dio.get("/auth/generate-token",options: Options(headers: {"Authorization" : "Bearer $token"}));
         print("respuesta del token de get ${responce.data}");
         return responce.data;
      }
        on DioException  catch(e)
      {
        print("Error al obtener el token ${e.response?.data ??e.message}  ");
        return null;
      }
    }


}