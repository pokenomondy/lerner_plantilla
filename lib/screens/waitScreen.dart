import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';

class waitScreenBuild extends StatelessWidget {
  const waitScreenBuild({super.key});

  @override
  Widget build(BuildContext context){

    final currentwidth = MediaQuery.of(context).size.width;
    final currentheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          width: currentwidth,
          height: currentheight ,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment(0,0.3),
              colors: [Config.second_color, Colors.white.withOpacity(0)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dibujarLogo(),
              _escribirFrase(),
              LinearProgressIndicator()
            ],
          ),
        ),
    );
  }
}

class _dibujarLogo extends StatelessWidget{
  const _dibujarLogo({Key?key,}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text("Lernen", style: TextStyle(
            fontSize: 75,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Config.second_color,
            height: 0.4
        ),),
        Text("Aprendizaje efectivo", style: TextStyle(
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
            color: Config.gray_color
        ),)
      ],
    );
  }
}

class _escribirFrase extends StatelessWidget {
  const _escribirFrase({Key?key,}) : super(key : key);

  @override
  Widget build(BuildContext context){
   return Container(
     margin: EdgeInsets.only(top: 60, bottom: 40),
     child: RichText(
       textAlign: TextAlign.center,
         text: TextSpan(
       style: TextStyle(
         color: Config.gray_color,
         fontFamily: "Poppins",
         fontSize: 18,
         fontWeight: FontWeight.w300
       ),
         children: [
         TextSpan(text: "Preparate para tus "),
         TextSpan(text: "examenes\n", style: TextStyle(
           color: Config.second_color,
           fontWeight: FontWeight.w500
         )),
         TextSpan(text: " de la mejor manera")
       ]
     )),
   );
  }
}