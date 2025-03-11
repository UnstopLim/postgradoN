import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Estado/ApiClientRiberput.dart';

@RoutePage()
class Login extends ConsumerStatefulWidget {
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
  String? _errorMessage;

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

  Future<void> _saveCredentials() async {
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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Por favor ingrese su usuario y contraseña.';
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
      } else {
        setState(() {
          _errorMessage = 'Usuario o contraseña incorrectos.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Usuario o contraseña incorrectos.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      height: isLandscape ? screenHeight * 0.4 : screenHeight * 0.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF230000), Color(0xFF002A55), Color(0xFF004D97)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(80),
                          bottomRight: Radius.circular(80),
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
                          width: screenWidth * 0.35,
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

                            if (_errorMessage != null) ...[
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],

                            SizedBox(height: screenHeight * 0.02),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004D97),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
