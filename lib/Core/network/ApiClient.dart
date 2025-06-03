
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
          final errorMessage = e.response?.data?['message'] ?? "Error desconocido";
          print("Error en login: $errorMessage");
          throw errorMessage;
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
           final responce = await dio.get("/usuario/my-data",options: Options(headers: {"Authorization" : "Bearer $token"}) );
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
    //enpoint Update
    Future<Map<String, dynamic>> updatePassword({
      required String password,
      required String newPassword,
      required String confirmPassword,
    }) async {
      try {
        final token = await secureStorage.read(key: 'auth_token');
        if (token == null) {
          throw Exception('No se encontró el token de autenticación');
        }

        final response = await dio.post(
          "/usuario/update-password",
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: {
            "password": password,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword,
          },
        );

        return response.data;
      } on DioException catch (e) {
        if (e.response != null) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        }
        throw Exception('Error al cambiar la contraseña: ${e.message}');
      }
    }

    Future<Map<String, dynamic>?> uploadImages({
      required String frontImagePath,
      required String backImagePath,
      required String frontTituloPath,
      required String backTituloPath,
    })
    async {
        try
        {
          final token = await secureStorage.read(key: 'auth_token');
          if(token==null)
          {
              throw Exception("No se encontro el token de autorizacion");
          }

          FormData formData = FormData.fromMap({
            'carnet_anverso': await MultipartFile.fromFile(frontImagePath, filename: 'carnet_anverso.jpg',),
            'carnet_reverso': await MultipartFile.fromFile(backImagePath, filename: 'carnet_reverso.jpg',),
            'titulo_anverso': await MultipartFile.fromFile(frontTituloPath, filename: 'titulo_anverso.jpg',),
            'titulo_reverso': await MultipartFile.fromFile(backTituloPath, filename: 'titulo_reverso.jpg',),
          });

          final response = await dio.post(
            "/imeges",
            data: formData,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'multipart/form-data',
              },
            ),
          );

          return response.data;
        } on DioException catch (e) {
          final errorMessage = e.response?.data?['message'] ?? "Error al subir imágenes";
          print("Error en uploadImages: $errorMessage");
          throw errorMessage;
        }
    }







}