import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';
import 'package:lerner_plantilla/Pages/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Config/ConfigGeneral.dart';
import 'Objetos/Contenido.dart';
import 'Objetos/Subtemas.dart';
import 'Objetos/Temas.dart';
import 'package:lerner_plantilla/screens/waitScreen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "build-wait-screen",
      routes: {
        'build-wait-screen': ( _ ) => waitScreenBuild()
      },
    );
  }
}
