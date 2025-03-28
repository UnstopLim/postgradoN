import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:postgrado/Core/network/ApiClient.dart';
import 'package:postgrado/Feacture/Home/data/repository/tokenRepository.dart';
import 'package:postgrado/Feacture/Home/domain/caso_de_uso/token_case_uso.dart';
import 'package:postgrado/Feacture/Login/data/repository/auth_repository.dart';
import 'package:postgrado/Feacture/Login/domain/login_caso_uso/LoginUseCase.dart';
import 'package:postgrado/Feacture/Perfil/data/repository/PerfilRepository.dart';
import 'package:postgrado/Feacture/Perfil/domain/case_use/GetUserProfileCaseUse.dart';


final  getIt = GetIt.instance;

void setupLocator() {
  //inyeccion de la api
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  //login
  getIt.registerLazySingleton<auth_repository>(() => auth_repository(getIt<ApiClient>()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<auth_repository>()));
  getIt.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  //perfil
  getIt.registerLazySingleton<PerfilRepository>(() => PerfilRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase(getIt<PerfilRepository>()));
  //token
  getIt.registerLazySingleton<tokenRepository>(() => tokenRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<GetTokenCaseUse>(() => GetTokenCaseUse(getIt<tokenRepository>()));

}

