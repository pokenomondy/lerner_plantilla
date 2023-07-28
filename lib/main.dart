import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';
import 'package:lerner_plantilla/Pages/Dashboard.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "/home",
      routes: {
        '/': ( _ ) => const waitScreenBuild(),
        '/home': (context) => const Dashboard(),
        '/home/temario': (context) => Temario()
      },
    );
  }
}
