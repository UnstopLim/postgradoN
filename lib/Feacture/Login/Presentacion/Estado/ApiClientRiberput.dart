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

  /// 🟢 Login que valida credenciales y guarda token + tiempo de expiración
  Future<bool> login(String username, String password) async {
    try {
      final response = await loginUseCase.execute(username, password);

      /// Validamos si la respuesta viene correcta
      if (response != null &&
          response.containsKey("token") &&
          response.containsKey("expiresIn")) {
        final token = response["token"];
        final expiresIn = response["expiresIn"]; // Tiempo en segundos

        /// Calculamos el tiempo exacto de expiración
        final expirationDate = DateTime.now()
            .add(Duration(seconds: expiresIn))
            .toIso8601String();

        /// Guardamos el token y la expiración
        await _saveToken(token, expirationDate);

        /// Actualizamos el estado del provider
        state = token;

        print('Login exitoso. Token guardado.');
        return true; // ✅ Login correcto
      } else {
        print('Credenciales inválidas o respuesta incorrecta.');
        return false; // ❌ Login fallido
      }
    } catch (e) {
      print('Error en login: $e');
      return false; // ❌ Login fallido
    }
  }

  /// 🟢 Logout, limpia todo
  Future<void> logout() async {
    state = null;
    await _removeToken();
  }

  /// 🔒 Guarda el token y su expiración
  Future<void> _saveToken(String token, String expirationDate) async {
    await secureStorage.write(key: 'auth_token', value: token);
    await secureStorage.write(key: 'auth_token_expiration', value: expirationDate);
  }

  /// 🔓 Carga el token solo si no ha expirado
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
