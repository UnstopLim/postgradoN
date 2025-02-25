
import 'dart:async';
import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/CustomAppBar.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Widgeth/drawer.dart';

@RoutePage()
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _ViewState();
}

class _ViewState extends State<Home> {
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

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFFDDDDDD),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              "assets/edificio.png",
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.015,
                      horizontal: screenSize.width * 0.08,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Tiempo restante",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.005),
                        Text(
                          "00:${_seconds.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'RobotoMono',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.05),

                  // Contenedor del token
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.08,
                      vertical: screenSize.height * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline_rounded, size: screenSize.width * 0.15, color: Colors.grey),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          _token,
                          style: TextStyle(
                            fontSize: screenSize.width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E0000),
                            fontFamily: 'Courier',
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.03),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isGeneratingToken ? null : _generateToken,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00366C),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                              elevation: 4,
                              shadowColor: Colors.blueAccent.withOpacity(0.3),
                            ),
                            child: Text(
                              _isGeneratingToken ? "Generando..." : "Generar Token",
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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

      drawer: CustomDrawer(),
    );
  }
}
