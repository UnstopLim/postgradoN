import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:postgrado/Core/Navigator/AppRouter.gr.dart';

@RoutePage()
class Curs extends StatefulWidget {
  const Curs({super.key});

  @override
  State<Curs> createState() => _CursState();
}

class _CursState extends State<Curs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:                  ElevatedButton(
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
    );
  }
}
