
import 'package:postgrado/Feacture/Login/data/repository/auth_repository.dart';

class LoginUseCase
{
  final auth_repository repository;
  LoginUseCase(this.repository);
  Future<Map<String,dynamic>?> execute(String username,String password)
  async
  {
    return await repository.login(username, password);
  }
}