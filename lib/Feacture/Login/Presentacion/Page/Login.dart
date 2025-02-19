import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginDaoState();
}

class _LoginDaoState extends State<Login> {

  final TextEditingController num1= TextEditingController();
  final TextEditingController num2= TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeigth,
          child: Stack(
            children: [
              Container(
                height: screenHeigth*0.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue,Colors.blue.shade900]
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(150),
                        bottomRight: Radius.circular(150)

                    )
                ),
                child: Center(
                    child: Icon(Icons.school,size: 110,color: Colors.white,)
                ),
              ),
              Positioned(
                top: screenHeigth*0.36,
                left: 40,
                right: 40,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(0, 5)
                        ),
                      ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 25),
                      Text("Bienvenido",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(height: 70),
                      TextField(
                        controller: num1,
                        decoration: const InputDecoration(labelText: "E-Mail",border: OutlineInputBorder() ),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        controller: num2,
                        decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: (){
                          context.router.push(Home());
                        },
                        child: Text(" Log in",style: TextStyle(fontSize: 20,color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 100)

                        ),
                      ),

                      SizedBox(height: 30),
                      Text("¿Olvidaste tu contraseña?"),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




