import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Pages/dashboard.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';
import 'package:lerner_plantilla/Pages/wait_screen.dart';

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
      initialRoute: "/home",
      routes: {
        '/': (context) => const WaitScreenBuild(),
        '/home': (context) => const Dashboard(),
        '/home/temario': (context) => Temario(),
      }, onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder: (context) => const WaitScreenBuild()
        );
    },
    );
  }
}
