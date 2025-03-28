import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; // 👈 Necesario para copiar al portapapeles
import 'package:postgrado/Feacture/Home/Presentacion/estado/TokenProvider.dart';

@RoutePage()
class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  int _seconds = 60;
  String _token = "Cargando...";
  bool _isGeneratingToken = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  // Obtiene el token inicial de la API
  Future<void> _fetchToken() async {
    setState(() {
      _isGeneratingToken = true;
    });

    // Refresca el provider para obtener un nuevo token
    final tokenResponse = await ref.refresh(TokenProvider.future);

    if (tokenResponse != null) {
      setState(() {
        _token = tokenResponse.token ?? "Token no disponible";
        _seconds = _parseTtl(tokenResponse.ttlToken.toString());
        _isGeneratingToken = false;
      });

      // Reiniciar el temporizador
      _startTimer();
    } else {
      setState(() {
        _token = "Error al obtener el token";
        _isGeneratingToken = false;
      });
    }
  }


  // Convierte "60 s" a un número entero
  int _parseTtl(String ttlToken) {
    return int.tryParse(ttlToken.split(" ")[0]) ?? 60;
  }

  // Inicia el temporizador con el tiempo recibido de la API
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _token = "Token expiró"; // 👈 Muestra mensaje cuando el tiempo llegue a 0
          _timer?.cancel(); // 👈 Detiene el temporizador
        }
      });
    });
  }

  // Copia el token al portapapeles
  void _copyToken() {
    if (_token.isNotEmpty && _token != "Token expiró" && _token != "Cargando...") {
      Clipboard.setData(ClipboardData(text: _token));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token copiado al portapapeles")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "assets/edificio.png",
                  fit: BoxFit.contain,
                  width: screenSize.width * 0.99,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.1),
                  Text("Tiempo de token",
                      style: TextStyle(fontSize: screenSize.width * 0.05, fontWeight: FontWeight.w500)),
                  Text("00:${_seconds.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: screenSize.width * 0.08, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Image.asset("assets/pass1.png",
                      width: screenSize.width * 0.25, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Text(" Token Generado"),
                  Text(
                    _token,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E0000),
                      fontFamily: 'Courier',
                      letterSpacing: 2.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: _copyToken, // 👈 Llama a la función para copiar
                        icon: Icon(Icons.copy, color: Colors.black54, size: 20),
                        label: Text(
                          "Copiar",
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isGeneratingToken ? null : _fetchToken, // 👈 Ahora siempre genera un nuevo token
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF003667),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                        elevation: 5,
                      ),
                      child: Text(
                        _isGeneratingToken ? "Generando..." : "Generar token",
                        style: TextStyle(fontSize: screenSize.width * 0.05, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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
}
