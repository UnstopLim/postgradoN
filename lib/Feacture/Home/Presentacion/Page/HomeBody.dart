import 'dart:async';
import 'dart:math';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int _seconds = 60;
  String _token = "123456";
  bool _isGeneratingToken = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _generateToken();
          _seconds = 60;
        }
      });
    });
  }

  void _generateToken() {
    setState(() {
      _isGeneratingToken = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _token = (Random().nextInt(900000) + 100000).toString();
        _isGeneratingToken = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/edificio.png",
                fit: BoxFit.contain,
                width: screenSize.width * 0.98,
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
                Image.asset("assets/seguridad.png", width: screenSize.width * 0.2, fit: BoxFit.contain),
                SizedBox(height: 20),
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
                      onPressed: () {},
                      icon: Icon(Icons.copy, color: Colors.black54, size: 20),
                      label: Text(
                        "Copiar",
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("Tiempo de token", style: TextStyle(fontSize: screenSize.width * 0.05, fontWeight: FontWeight.w500)),
                Text("00:${_seconds.toString().padLeft(2, '0')}", style: TextStyle(fontSize: screenSize.width * 0.08, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isGeneratingToken ? null : _generateToken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00366C),
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
    );
  }
}
