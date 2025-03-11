import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:postgrado/Core/di/service_locator.dart';
import 'package:postgrado/Feacture/Login/domain/login_caso_uso/LoginUseCase.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(getIt<LoginUseCase>(), getIt<FlutterSecureStorage>());
});

class AuthNotifier extends StateNotifier<String?>
{
    final LoginUseCase loginUseCase;
    final FlutterSecureStorage secureStorage;
    AuthNotifier(this.loginUseCase, this.secureStorage) : super(null) {
      _loadToken();
    }

    Future<bool> login(String username, String password)
    async
    {
      try
      {
          final response = await loginUseCase.execute(username, password);
          if (response != null && response.containsKey("token") && response.containsKey("expiresIn"))
          {
            final token = response["token"];
            final expiresIn = response["expiresIn"];

            final expirationDate = DateTime.now()
                .add(Duration(seconds: expiresIn))
                .toIso8601String();
            await _saveToken(token, expirationDate);
            state = token;

            print('Login exitoso. Token guardado.');
            return true;
          } else {
            print('Credenciales inválidas o respuesta incorrecta.');
            return false;
          }
      } catch (e) {
        print('Error en login: $e');
        return false;
      }
    }


    Future<void> logout() async {
      state = null;
      await _removeToken();
    }


    Future<void> _saveToken(String token, String expirationDate) async {
      await secureStorage.write(key: 'auth_token', value: token);
      await secureStorage.write(key: 'auth_token_expiration', value: expirationDate);
    }


    Future<void> _loadToken() async {
      final token = await secureStorage.read(key: 'auth_token');
      final expirationDateStr = await secureStorage.read(key: 'auth_token_expiration');

      if (token != null && expirationDateStr != null) {
        final expirationDate = DateTime.parse(expirationDateStr);
        final now = DateTime.now();

        if (expirationDate.isAfter(now)) {
          state = token;
          print('Token válido cargado.');
        } else {
          print('Token expirado. Se eliminará.');
          await _removeToken();
        }
      } else {
        print('No hay token guardado.');
      }
    }

    /// 🗑️ Elimina el token y su expiración
    Future<void> _removeToken() async {
      await secureStorage.delete(key: 'auth_token');
      await secureStorage.delete(key: 'auth_token_expiration');
    }
}
