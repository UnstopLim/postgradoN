
import 'package:json_annotation/json_annotation.dart';
part 'CambioModel.g.dart';

@JsonSerializable()
class CambioModel {
  final String password;
  final String newPassword;
  final String confirmPassword;

  CambioModel({
    required this.password,
    required this.newPassword,
    required this.confirmPassword,
  });

  void validate() {
    if (newPassword != confirmPassword) {
      throw Exception('Las contraseñas no coinciden');
    }

    if (newPassword.length < 8) {
      throw Exception('La contraseña debe tener al menos 8 caracteres');
    }

    if (!newPassword.contains(RegExp(r'[A-Z]'))) {
      throw Exception('La contraseña debe contener al menos una mayúscula');
    }

    if (!newPassword.contains(RegExp(r'[0-9]'))) {
      throw Exception('La contraseña debe contener al menos un número');
    }

    if (!newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      throw Exception('La contraseña debe contener al menos un carácter especial');
    }
  }
}
