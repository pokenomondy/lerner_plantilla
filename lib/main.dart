import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lerner_plantilla/Pages/Parciales.dart';
import 'package:lerner_plantilla/Pages/dashboard.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';
import 'package:lerner_plantilla/Pages/wait_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: ["5A4EE9956F89D6710AD33EE668544AA0"]);
  MobileAds.instance.updateRequestConfiguration(configuration);
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
        '/home/parciales': (context) => Parcialesvista(),
      }, onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder: (context) => const WaitScreenBuild()
        );
    },
    );
  }
}
