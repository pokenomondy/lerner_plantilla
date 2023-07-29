import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Pages/Dashboard.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';
import 'package:lerner_plantilla/Pages/wait_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Config/ConfigGeneral.dart';
import 'Objetos/Contenido.dart';
import 'Objetos/Subtemas.dart';
import 'Objetos/Temas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "/",
            routes: {
        '/': (context) => const WaitScreenBuild(),
        '/home': (context) => const Dashboard(),
        '/home/temario': (context) => Temario(),
      }, onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder: (context) => const WaitScreenBuild()
        );
    },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        dividerColor: Colors.transparent,
      ),
    );
  }
}




