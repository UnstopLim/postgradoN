
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/Login/domain/login_caso_uso/LoginUseCase.dart';


final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(getIt<LoginUseCase>(), getIt<FlutterSecureStorage>());
});

class AuthNotifier extends StateNotifier<String?> {
  final LoginUseCase loginUseCase;
  final FlutterSecureStorage secureStorage;

  AuthNotifier(this.loginUseCase, this.secureStorage) : super(null) {
    _loadToken();
  }

  Future<void> login(String username, String password) async {
    final response = await loginUseCase.execute(username, password);
    if (response != null && response.containsKey("token")) {
      final token = response["token"];
      state = token;
      await _saveToken(token);
    } else {
      print("Error: La respuesta no contiene un token válido.");
    }
  }

  Future<void> logout() async {
    state = null;
    await _removeToken();
  }

  Future<void> _saveToken(String token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> _loadToken() async {
    final token = await secureStorage.read(key: 'auth_token');
    state = token;
  }

  Future<void> _removeToken() async {
    await secureStorage.delete(key: 'auth_token');
  }
}
