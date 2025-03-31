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
  _CambioState createState() => _CambioState();
}

class _CambioState extends ConsumerState<Cambio> {
   final TextEditingController passwordController = TextEditingController();
   final TextEditingController newPasswordController = TextEditingController();
   final TextEditingController confirmPasswordController = TextEditingController();
   bool _isLoading = false;


  final _formKey = GlobalKey<FormState>();
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;


  Future<void> _cambioPassword()
   async
   {
      final hayInternet = await NetworkInfo().isConnected();
      if(!hayInternet)
      {
         showDialog(context: context, builder: (BuildContext context) {
           return ErroConection();
         });
         return;
      }
      final password = passwordController.text.trim();
      final newPassword = newPasswordController.text.trim();
      final confirmPassword= confirmPasswordController.text.trim();
      try
      {
        await ref.read(cambioProvider.notifier).CambioPassword(password, newPassword, confirmPassword);
        setState(() {
          final snakBar = SnackBar(content: const Text("Se cambio la contraseña correctamente"),
              action: SnackBarAction(label: 'Ok', onPressed: () {}));
          ScaffoldMessenger.of(context).showSnackBar(snakBar);
        });
      }catch(e){
        setState(() {
          final snakBar = SnackBar(content: const Text("No se modifico la contraseña"),
              action: SnackBarAction(label: 'Ok', onPressed: () {}));
          ScaffoldMessenger.of(context).showSnackBar(snakBar);
        });
      }
   }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(

      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.0),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Cambio de Contraseña",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ingresa tu contraseña actual y la nueva",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPasswordField("Contraseña Actual",passwordController, _isObscureOld, () {
                          setState(() {
                            _isObscureOld = !_isObscureOld;
                          });
                        }),
                        SizedBox(height: 15),
                        _buildPasswordField("Nueva Contraseña",newPasswordController, _isObscureNew, () {
                          setState(() {
                            _isObscureNew = !_isObscureNew;
                          });
                        }),
                        SizedBox(height: 15),
                        _buildPasswordField("Confirmar Nueva Contraseña",confirmPasswordController, _isObscureConfirm, () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
                          });
                        }),
                        SizedBox(height: screenSize.height * 0.05),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Acción para cambiar la contraseña
                                _isLoading ?  null: _cambioPassword();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Contraseña cambiada exitosamente")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF003F77),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              elevation: 4,
                              shadowColor: Colors.blueAccent.withOpacity(0.3),
                            ),
                            child:  _isLoading
                               ? const CircularProgressIndicator(color: Colors.white,)
                                :const Text("Cambiar contraseña",style: TextStyle(fontSize: 18,color: Colors.white),)
                            ,
                            // child: Text(
                            //   "Cambiar Contraseña",
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label,TextEditingController controllerEdit, bool isObscure, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controllerEdit,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo no puede estar vacío";
        }
        return null;
      },
    );
  }
}
