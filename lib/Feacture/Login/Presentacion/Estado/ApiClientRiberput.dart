
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:postgrado/Core/network/ApiClient.dart';
import 'package:postgrado/Feacture/Login/data/repository/auth_repository.dart';
import 'package:postgrado/Feacture/Login/domain/login_caso_uso/LoginUseCase.dart';

final apiClintProv = Provider((ref) => ApiClient());
final AuthRepositoryProv = Provider((ref) => auth_repository(ref.watch(apiClintProv)));
final AuthUseCaseProv = Provider((ref) => LoginUseCase(ref.watch(AuthRepositoryProv)));

final authProvider = StateNotifierProvider<AuthNotifier,String?>((ref)
{
  return AuthNotifier(ref.watch(AuthUseCaseProv));
});
class AuthNotifier extends StateNotifier<String?>{
   final LoginUseCase loginUseCase;
   final FlutterSecureStorage secureStorage = FlutterSecureStorage();
   AuthNotifier(this.loginUseCase) : super(null){
     //_loadtoken();
   }

}