import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Estado/ApiClientRiberput.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/AlertDialogConection.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/network_info.dart';

@RoutePage()
class Login extends ConsumerStatefulWidget
{
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends ConsumerState<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final savedUsername = await secureStorage.read(key: 'saved_username');
    final savedPassword = await secureStorage.read(key: 'saved_password');
    final savedRememberMe = await secureStorage.read(key: 'remember_me');
    if (savedRememberMe == 'true') {
      setState(() {
        emailController.text = savedUsername ?? '';
        passwordController.text = savedPassword ?? '';
        rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async
  {
    if (rememberMe) {
      await secureStorage.write(key: 'saved_username', value: emailController.text);
      await secureStorage.write(key: 'saved_password', value: passwordController.text);
      await secureStorage.write(key: 'remember_me', value: 'true');
    } else {
      await secureStorage.delete(key: 'saved_username');
      await secureStorage.delete(key: 'saved_password');
      await secureStorage.write(key: 'remember_me', value: 'false');
    }
  }

  Future<void> _handleLogin() async {

    final hayInternet = await NetworkInfo().isConnected();
    if (!hayInternet) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErroConection();
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        final snakBar = SnackBar(content: const Text("Por favor ingrese su usuario y contraseña.",style: TextStyle(color: Colors.black),),
            backgroundColor: Color(0xFFC3C3C3)
            ,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: 'Ok', onPressed: () {}));
        ScaffoldMessenger.of(context).showSnackBar(snakBar);
      });
      return;
    }

    try {
      await ref.read(authProvider.notifier).login(email, password);
      final token = ref.read(authProvider);
      if (token != null && token.isNotEmpty) {
        await _saveCredentials();
        if (!mounted) return;
        context.router.replace(Home());
      }
      else
      {
        setState(() {
          final snakBar = SnackBar(content: const Text("Usuario no encontrado"),
              action: SnackBarAction(label: 'Ok', onPressed: () {}));
          ScaffoldMessenger.of(context).showSnackBar(snakBar);
        });
      }
    } catch (e) {
      setState(() {
        final snakBar = SnackBar(content: const Text("Contraseña incorrecta"),
            action: SnackBarAction(label: 'Ok', onPressed: () {}));
        ScaffoldMessenger.of(context).showSnackBar(snakBar);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verf() async
  {
    final hayInternet = await NetworkInfo().isConnected();
    if(!hayInternet)
    {
        showDialog(context: context,builder: (BuildContext context)
        {
          return ErroConection();
        }) ;
        return;
    }
    context.router.push(Recuperar());
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;


    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // Fondo degradado
                    Container(
                      height: isLandscape ? screenHeight * 0.4 : screenHeight * 0.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF0074E8), Color(0xFF003468), Color(0xFF001B42)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(150),
                          bottomRight: Radius.circular(150),
                        ),
                      ),
                    ),

                    Positioned(
                      top: screenHeight * 0.10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/logo2.png",
                          width: screenWidth * 0.65,
                          height: screenWidth * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    Positioned(
                      top: isLandscape ? screenHeight * 0.15 : screenHeight * 0.33,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              "Bienvenido",
                              style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                            ),
                            Text(
                              "A Posgrado Token",
                              style: TextStyle(color: Color(0xFF700015), fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            TextField(
                              controller: emailController,
                              focusNode: emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            TextField(
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text("Recordar contraseña"),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004D97),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Iniciar sesión', style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            TextButton(
                              onPressed: () {
                                _verf();
                              },
                              child: const Text("¿Olvidaste tu contraseña?", style: TextStyle(color: Color(0xFF004D97), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );






  }
}
