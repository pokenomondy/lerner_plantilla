import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Objetos/Subtemas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Objetos/Parciales.dart';
import '../Objetos/Temas.dart';
import '../Utils/search.dart';

class Config {
  static const Color primaryColor = Color(0xFF0528F0);
  static const Color secondColor = Color(0xFF0540F0);
  static const Color thirdColor = Color(0xFF6387F2);
  static const Color contrastColor = Color(0xFFF00505);
  static const Color whiteColor = Color(0xFFF2F2F2);
  static const Color grayColor = Color(0xFF3C3C3B);
  static const String temaApp = "CALCULO 1";
  static const Color greenColorParcial = Color(0xFF1EC702);


  BoxShadow aplicarSombra(double opacity, double spreadradius, double blur, Offset coordenadas){
    return BoxShadow(
        color: grayColor.withOpacity(opacity),
        spreadRadius: spreadradius,
        blurRadius: blur,
        offset: coordenadas
    );
  }

  TextStyle aplicarEstilo(Color color, double fontSize, bool isBold){
    FontWeight fontWeight = (isBold) ? FontWeight.w500 : FontWeight.w300;
    return TextStyle(
        fontWeight: fontWeight,
        color: color,
        fontFamily: "Poppins",
        fontSize: fontSize);
  }

  AppBar defaultAppBar(){
    return AppBar(
        actions: const <Widget>[
        SearchBuild()
    ]);
  }

  Future obtenerTemasDesdeFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temasJson = prefs.getString('temas_list') ?? '';
    List<dynamic> temasData = jsonDecode(temasJson);
    List temasList = temasData.map((temaData) => Temas.fromJson(temaData)).toList();
    return temasList;
  }

  Future obtenerParcialesDesdeFirebase() async {
    print("obteniendo parciales");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temasJson = prefs.getString('parcial_list') ?? '';
    List<dynamic> temasData = jsonDecode(temasJson);
    List parcialList = temasData.map((temasData) => Parciales.fromJson(temasData)).toList();
    print("lista de parciales $parcialList");
    return parcialList;
  }

  Future<List<Map<String, dynamic>>> obtenerDatosBuscador() async {
    List<Map<String, dynamic>> items = [];
    obtenerTemasDesdeFirebase().then((value) => items.add({"esSubtema": true, "Content":value}));
    obtenerParcialesDesdeFirebase().then((value) => items.add({"esSubtema": false, "Content":value}));
    return items;
  }

}