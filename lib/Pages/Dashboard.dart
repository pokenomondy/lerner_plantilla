import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';

class Dashboard extends StatelessWidget {

  const Dashboard({super.key});
  @override

  Widget build(BuildContext context){

    final currentwidth = MediaQuery.of(context).size.width;
    final currentheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _crearbuscador(currentwidth: currentwidth,),
            _crarBoton(title: "Ver temario", subtitle: "Oprima para ver el temario del area", currentwidth: currentwidth,),
            _crarBoton(title: "Hacer ejercicio", subtitle: "Ejercicios para prepararte para tus examenes", currentwidth: currentwidth,)
          ],
        ),
      ),
    );
  }

}

class _crearbuscador extends StatelessWidget{
  const _crearbuscador({Key?key, required this.currentwidth}): super(key:key);
  final currentwidth;

  @override
  Widget build(BuildContext context){
    return Container(
      width: currentwidth,
      height: 80,
      decoration: BoxDecoration(
        color: Config.second_color,
        boxShadow: [BoxShadow(
          color: Config.gray_color.withOpacity(0.30),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0,3)
        )]
      ),
      child: Center(
        child: Text("Buscador aqui", style: TextStyle(
          color: Config.white_color,
          fontSize: 18,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600
        ),),
      ),
    );
  }
}


class _crarBoton extends StatelessWidget{
  const _crarBoton({Key?key, required this.title, required this.subtitle, required this.currentwidth}) : super(key:key);
  final String title, subtitle;
  final double currentwidth;

  @override
  Widget build(BuildContext context){

    const radio_images = Radius.circular(15);

    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Config.white_color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(
          color: Config.gray_color.withOpacity(0.10),
          spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0,1)
        )]
      ),
      width: this.currentwidth - 30,
      child: Row(
        children: [
          Container(
            height: 70,
            width: 120,
            child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: radio_images, topRight: radio_images,),
                  child: Image.asset(
                    'assets/sources/temario.jpg',
                    width: 120,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10) ,
                  child: Text(this.title, style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Config.second_color,
                    fontFamily: "Poppins",
                    fontSize: 19
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(this.subtitle, style: TextStyle(
                      color: Config.gray_color,
                      fontFamily: "Poppins",
                      fontSize: 14
                  ), maxLines: null, textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

}