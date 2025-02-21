import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Feacture/Home/Presentacion/Page/drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _ViewState();
}

class _ViewState extends State<Home> {
  int token = 48556;
  Duration duration = const Duration(minutes: 57, seconds: 13);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration.inSeconds > 0) {
        setState(() {
          duration -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String timeString = "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: YellowHeaderClipper(),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      color: Colors.yellow.shade700,
                    ),
                  ),
                  ClipPath(
                    clipper: HeaderClipper(),
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF005EBC), Color(0xFF002244)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/logo1.png', width: 130,),
                          //Icon(Icons.school, color: Colors.white, size: 40),
                          //Text("Posgrado", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Tiempo de token", style: TextStyle(fontSize: 28, color: Colors.black )),
              const SizedBox(height: 10),
              Text(timeString, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 5),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.lock, size: 60, color: Colors.blueGrey),
                    const SizedBox(height: 10),
                    Text("$token", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      onPressed: () {},
                      child: const Text("Generar token", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}








