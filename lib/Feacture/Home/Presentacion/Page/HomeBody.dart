import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; // 👈 Necesario para copiar al portapapeles
import 'package:postgrado/Feacture/Home/Presentacion/estado/TokenProvider.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/AlertDialogConection.dart';
import 'package:postgrado/Feacture/Login/Presentacion/Page/network_info.dart';

@RoutePage()
class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody>
{
  int _seconds = 60;
  String _token = "...";
  Timer? _timer;
  bool valueEstate=false;
  String valueT="";

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken()
  async
  {
      final hayInternet = await NetworkInfo().isConnected();
      if(!hayInternet)
        {
          showDialog(
              context: context, builder: (BuildContext context) {
            return ErroConection();
          }
          );
          return;
        }
      setState(() {
        valueEstate=true;
      });
      final tokenResponse = await ref.refresh(TokenProvider.future);
      if (tokenResponse != null) {
        setState(() {
          _token = tokenResponse.token ?? "Token no disponible";
          _seconds = _parseTtl(tokenResponse.ttlToken.toString());
          valueT="Generado";
          valueEstate=false;
        });
        _startTimer();
      }
      else
      {
        setState(() {
          _token = "Error";
          valueEstate=true;
        });
      }
  }

  int _parseTtl(String ttlToken) {
    return int.tryParse(ttlToken.split(" ")[0]) ?? 60;
  }

  void _startTimer()
  {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _token = ".....";
          _timer?.cancel();
          valueEstate=true;
          valueT="Expiro";
        }
      });
    });
  }


  void _copyToken()
  {
      if (_token.isNotEmpty && _token != "....." && _token != "Cargando...")
      {
        Clipboard.setData(ClipboardData(text: _token));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Token copiado",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating
            ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
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
                  Text("",
                      style: TextStyle(fontSize: screenSize.width * 0.04)),
                  Text("00:${_seconds.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: screenSize.width * 0.09)),
                  SizedBox(height: 15),
                  Image.asset("assets/pass1.png",
                      width: screenSize.width * 0.25, fit: BoxFit.contain),
                  SizedBox(height: 20),
                  Text(" Token ${valueT}",style: TextStyle(fontSize: 20,color: Colors.black),),
                  Text(
                    _token,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.15,
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
                        onPressed: _copyToken,
                        icon: Icon(Icons.copy, color: Colors.black, size: 22),
                        label: Text(
                          "Copiar",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: valueEstate ? _fetchToken : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF003667),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                        elevation: 5,
                      ),
                      child: Text(
                        valueEstate ? "Generar token" : "Generar token",
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
