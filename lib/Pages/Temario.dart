import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Temario extends StatefulWidget {


  @override
  _TemarioState createState() => _TemarioState();
}

class _TemarioState extends State<Temario> {
  //variables
  final db = FirebaseFirestore.instance; //inicializar firebase

  @override
  void initState() {
    super.initState();
    descargarlistadematerias();
  }

  Future<void> descargarlistadematerias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_temas') ?? false;
    if(!datosDescargados){
      print("Datos no descargados, se van a descargar");
    }else{
      print("Datos descargados, se van a descargar");

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }


}