
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/CustomAppBar.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/drawer.dart';


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
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFFDDDDDD),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          SizedBox(height: 8),
          Text(
            "Tiempo restante",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            "00:${_seconds.toString().padLeft(2, '0')}",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'RobotoMono',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
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
                  Icon(Icons.lock_outline_rounded, size: 70, color: Colors.blueGrey[700]),
                  SizedBox(height: 15),
                  Text(
                    _token,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Courier',
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isGeneratingToken ? null : _generateToken,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0154A5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 4,
                        shadowColor: Colors.blueAccent.withOpacity(0.3),
                      ),
                      child: Text(
                        _isGeneratingToken ? "Generando..." : "Generar Token",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
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
