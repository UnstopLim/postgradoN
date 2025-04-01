import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postgrado/Feacture/CambiarPassword/presentacion/estado/CambioRiberput.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/AlertDialogConection.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/network_info.dart';

@RoutePage()
class Cambio extends ConsumerStatefulWidget {
  const Cambio({super.key});

  @override
  _CambioPasswordScreenState createState() => _CambioPasswordScreenState();
}

class _CambioPasswordScreenState extends ConsumerState<Cambio> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(cambioProvider.notifier).cambioPassword(
        password: _passwordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña cambiada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Limpiar formulario después del éxito
        _passwordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final state = ref.watch(cambioProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.08,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Cambio de Contraseña",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ingresa tu contraseña actual y la nueva contraseña",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Campo contraseña actual
                  _buildPasswordField(
                    label: "Contraseña Actual",
                    controller: _passwordController,
                    isObscure: _isObscureOld,
                    toggleVisibility: () => setState(() => _isObscureOld = !_isObscureOld),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña actual';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo nueva contraseña
                  _buildPasswordField(
                    label: "Nueva Contraseña",
                    controller: _newPasswordController,
                    isObscure: _isObscureNew,
                    toggleVisibility: () => setState(() => _isObscureNew = !_isObscureNew),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una nueva contraseña';
                      }
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Debe contener al menos una mayúscula';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Debe contener al menos un número';
                      }
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Debe contener al menos un carácter especial';
                      }
                      return null;
                    },
                    helperText: 'Mínimo 8 caracteres con mayúsculas, números y caracteres especiales',
                  ),
                  const SizedBox(height: 20),

                  // Campo confirmar contraseña
                  _buildPasswordField(
                    label: "Confirmar Nueva Contraseña",
                    controller: _confirmPasswordController,
                    isObscure: _isObscureConfirm,
                    toggleVisibility: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                    validator: (value) {
                      if (value != _newPasswordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Botón de enviar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003F77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Cambiar Contraseña",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        helperText: helperText,
      ),
      validator: validator,
    );
  }
}