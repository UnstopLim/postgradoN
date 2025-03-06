
import 'package:dio/dio.dart';

class ApiClient
{
    final Dio dio;
    ApiClient({Dio? dio})
        :dio = dio ?? Dio(BaseOptions(baseUrl: "https://api-preinscripcion.posgradoupea.edu.bo/api/v1"));

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
        }
    }
}