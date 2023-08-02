import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/config_general.dart';
import '../Objetos/Contenido.dart';
import '../Objetos/Parciales.dart';
import '../Objetos/Subtemas.dart';
import '../Objetos/Temas.dart';

void main() => runApp(const WaitScreenBuild());

class WaitScreenBuild extends StatelessWidget {
  const WaitScreenBuild({super.key});

  @override
  Widget build(BuildContext context){
    return const _CargarDatos();
  }
}

class _CargarDatos extends StatefulWidget{
  const _CargarDatos({Key?key}): super(key:key);

  @override
  _CargarDatosState createState() => _CargarDatosState();
}

class _CargarDatosState extends State<_CargarDatos> {

  final db = FirebaseFirestore.instance; //inicializar firebase
  List<Temas> temasList = [];
  List<Parciales> parcialesList = [];
  bool isLoading = false;
  double progressValue = 0.0;
  String progresstext = "0.0";
  bool _datosdescargados = false; //datos descargados por parte de firebase

  @override
  void initState() {
    super.initState();
    actualizarapp();
    _initGoogleMobileAds;
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  Future actualizarapp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_actualizacion') ?? false;
    if (!datosDescargados) {
      //Obtener actualización de temas
      DocumentSnapshot getactualizacion = await FirebaseFirestore.instance
          .collection("MATERIAS").doc(Config.temaApp).get();
      DateTime actualizacion = getactualizacion.get('fecha actualizacion')
          .toDate();
      //obtenemos actualización de temas
      DocumentSnapshot getactualizacionparcial = await FirebaseFirestore.instance
          .collection("PARCIALES").doc(Config.temaApp).get();
      DateTime actualizacionparcial = getactualizacionparcial.get('fecha actualizacion')
          .toDate();
      //guardo actualizacion temas
      await prefs.setString("actualizacionTemas", actualizacion.toString()); // Guardamos en shared preferecnes
      await prefs.setBool('datos_actualizacion', true);
      obtenerTemasDesdeFirebase();
      obtenerParcialesDesdeFirebase();
      //guardaractualizacion de parciales
      await prefs.setString("actualizacionParciales", actualizacionparcial.toString()); // Guardamos en shared preferecnes
    } else {
      //temas
      DocumentSnapshot getactualizacion = await FirebaseFirestore.instance.collection("MATERIAS").doc(Config.temaApp).get();
      DateTime actualizacion = getactualizacion.get('fecha actualizacion').toDate();
      String act = prefs.getString('actualizacionTemas') ?? '';
      DateTime actguardado = DateTime.parse(act);
      if (actguardado == actualizacion) {
        print("no descargando temas");
        obtenerTemasDesdeFirebase();
      } else {
        print("descargar nuevos temas");
        //eliminar variables para actualizar
        await prefs.remove('temas_list');
        await prefs.setBool('datos_descargados_listatemas', false);
        await prefs.remove('actualizacionTemas');
        await prefs.setString("actualizacionTemas", actualizacion.toString()); // Guardamos en shared preferecnes
        obtenerTemasDesdeFirebase();
      }
      //parciales
      DocumentSnapshot getactualizacionparcial = await FirebaseFirestore.instance.collection("PARCIALES").doc(Config.temaApp).get();
      DateTime actualizacionparcial = getactualizacionparcial.get('fecha actualizacion').toDate();
      String actparcial = prefs.getString('actualizacionParciales') ?? '';
      DateTime actguardadoparcial = DateTime.parse(actparcial);

      if(actualizacionparcial==actguardadoparcial){
        obtenerParcialesDesdeFirebase();
      }else{
        await prefs.remove('parcial_list');
        await prefs.setBool('datos_descargados_parciales', false);
        await prefs.remove('actualizacionParciales');
        await prefs.setString("actualizacionParciales", actualizacionparcial.toString()); // Guardamos en shared preferecnes
        obtenerParcialesDesdeFirebase();
      }

    }
  }

  Future obtenerTemasDesdeFirebase() async {
    startprogressindicator(_datosdescargados);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_listatemas') ??
        false;
    if (!datosDescargados) {
      print("descargando datos de cero");
      // print("Los datos apenas se van a descargar, priemra vez");
      CollectionReference referenceTemas = FirebaseFirestore.instance
          .collection("MATERIAS").doc(Config.temaApp).collection("TEMAS");
      QuerySnapshot queryTemas = await referenceTemas.get();

      for (var temaDoc in queryTemas.docs) {
        String nombreTema = temaDoc['nombre Tema'];
        int ordenTema = temaDoc['Orden tema'];
         print("$ordenTema $nombreTema");

        //Ahora metemos subtemas para crear la lista y guardar
        QuerySnapshot subtemasDocs = await temaDoc.reference.collection(
            'SUBTEMAS').get();
        List<SubTemas> subtemasList = [];
        for (var subtemaDoc in subtemasDocs.docs) {
          String nombreSubTema = subtemaDoc['nombreSubTema']; // Suponiendo que 'nombreSubTema' es el campo que contiene el nombre del subtema
          int ordenSubtema = subtemaDoc['ordenSubtema'];
           print("$ordenSubtema $nombreSubTema");

          //Ahora cargamos el contenido
          QuerySnapshot contenidoDocs = await subtemaDoc.reference.collection(
              "CONTENIDO").get();

          List<Contenido> contenidos = [];
          List<Map<String, dynamic>> contenidoData = [];
          for (var contenidoDoc in contenidoDocs.docs) {
            final data = contenidoDoc.data() as Map<String, dynamic>;
            contenidoData =
                (data['contenido'] as List).cast<Map<String, dynamic>>();
            Contenido contenido = Contenido(contenidoData,);
            contenidos.add(contenido);
             print("contenido = $contenidoData");
          }
          //guaramos subtemas
          SubTemas subtema = SubTemas(nombreSubTema, ordenSubtema, contenidos);
          subtemasList.add(subtema);
        }

        Temas tema = Temas(nombreTema, ordenTema, subtemasList);
        temasList.add(tema);
      }

      setState(() {
        _datosdescargados = true;
      });

      print("a guardar temas parece");
      guardardatos("guardando temas");
      startprogressindicator(_datosdescargados);

      return temasList;
    } else {
      print("temas ya en sharedpreferences");
      setState(() {
        _datosdescargados = true;
        startprogressindicator(datosDescargados);
      });
    }
  }

  Future obtenerParcialesDesdeFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_parciales') ?? false;
    if (!datosDescargados) {

      CollectionReference referenceParciales = FirebaseFirestore.instance
          .collection("PARCIALES")
          .doc(Config.temaApp)
          .collection("PARCIALES");
      QuerySnapshot queryParciales = await referenceParciales.get();

      for (var parcialDoc in queryParciales.docs) {
        String fraseParcial = parcialDoc['fraseparcial'];
        String universidad = parcialDoc['universidad'];
        String materia = parcialDoc['materia'];
        List<dynamic> temaDynamic = parcialDoc['tema'];
        List<dynamic> subtemasDynamic = parcialDoc['subtemas'];
        List<String> tema = temaDynamic.cast<String>();
        List<String> subtemas = subtemasDynamic.cast<String>();
        String indicedificultad = parcialDoc['indicedificultad'];

          //cargamos contenido
          QuerySnapshot contenidoDocs = await parcialDoc.reference.collection("CONTENIDO").get();
          List<Contenido> contenidos = [];
          List<Map<String,dynamic>> contenidoData = [];

          for (var contenidoDoc in contenidoDocs.docs){
            final data = contenidoDoc.data() as Map<String, dynamic>;
            contenidoData =
                (data['contenido'] as List).cast<Map<String, dynamic>>();
            Contenido contenido = Contenido(contenidoData,);
            contenidos.add(contenido);
          }
        Parciales newparcial = Parciales(fraseParcial, universidad, materia,
            tema, subtemas, indicedificultad,contenidos);
        parcialesList.add(newparcial);
      }
      guardardatos("parciales");
      return parcialesList;
    }else{
      _datosdescargados = true;
    }
  }

  void startprogressindicator(bool datosdescargados) {
    setState(() {
      isLoading = true;
      progressValue = 0;
    });

    const totalProgressTime = 2; // Tiempo total para llegar al 90%
    const steps = 50; // Cantidad de pasos para el incremento

    const stepDuration =  Duration(milliseconds: (totalProgressTime * 1000) ~/ steps);

    var currentStep = 0;

    if(datosdescargados==false){
      Timer.periodic(stepDuration, (timer) {
        currentStep++;
        setState(() {
          progressValue = currentStep / steps * 0.9;
          progresstext = (progressValue*100).toStringAsFixed(1);
        });

        if (currentStep == steps) {
          timer.cancel();

        }
      });
    }else{
      if (datosdescargados==true) {
        completeprogress(); // Iniciar el progreso del 90% al 100%
      }
    }





  }

  Future guardardatos(String parcialtema) async{
    if(parcialtema=="parciales"){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("se guardan datos de parciales");
      String temasJson = jsonEncode(parcialesList);
      await prefs.setString('parcial_list', temasJson); // Guardamos en shared preferecnes
      await prefs.setBool('datos_descargados_parciales', true);
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("se guardan datos en temas");
      String temasJson = jsonEncode(temasList); //convertios a Json para guardar
      await prefs.setString('temas_list', temasJson); // Guardamos en shared preferecnes
      await prefs.setBool('datos_descargados_listatemas', true);
    }
  }

  void completeprogress(){
    const completeDuration = 1000; // Tiempo para completar el 10% restante (desde el 90% hasta el 100%)
    const steps = 10; // Cantidad de pasos para el incremento

    const stepDuration = Duration(milliseconds: (completeDuration ~/ steps));
    var currentStep = 0;

    Timer.periodic(stepDuration, (timer) {
      currentStep++;
      setState(() {
        progressValue = 0.9 + (currentStep / steps * 0.1);
        progresstext = (progressValue * 100).toStringAsFixed(1);
      });

      if (currentStep == steps) {
        timer.cancel();
        setState(() {
          isLoading = false;
        });
      }
    });

    _redireccionaDashboarc();
  }

  void _redireccionaDashboarc() {
    Navigator.pushReplacementNamed(context, '/home');
  }


  @override
  Widget build(BuildContext context){

    final double currentwidth = MediaQuery.of(context).size.width;
    final double currentheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: currentwidth,
        height: currentheight ,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: const Alignment(0,0.3),
            colors: [Config.secondColor, Colors.white.withOpacity(0)],
          ),
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _DibujarLogo(),
            const _EscribirFrase(),
            SizedBox(
              width: currentwidth-180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: currentwidth-220,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: progressValue,
                              minHeight: 10,
                              valueColor: const AlwaysStoppedAnimation<Color>(Config.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(progresstext.toString()),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

}

class _DibujarLogo extends StatelessWidget{
  const _DibujarLogo({Key?key,}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return const Column(
      children: [
        Text("Lernen", style: TextStyle(
            fontSize: 75,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Config.secondColor,
            height: 0.8
        ),),
        Text("Aprendizaje efectivo", style: TextStyle(
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w300,
            color: Config.grayColor
        ),)
      ],
    );
  }
}

class _EscribirFrase extends StatelessWidget {
  const _EscribirFrase({Key?key,}) : super(key : key);

  @override
  Widget build(BuildContext context){
   return Container(
     margin: const EdgeInsets.only(top: 60, bottom: 40),
     child: RichText(
       textAlign: TextAlign.center,
         text: const TextSpan(
       style: TextStyle(
         color: Config.grayColor,
         fontFamily: "Poppins",
         fontSize: 18,
         fontWeight: FontWeight.w300
       ),
         children: [
         TextSpan(text: "Preparate para tus "),
         TextSpan(text: "examenes\n", style: TextStyle(
           color: Config.secondColor,
           fontWeight: FontWeight.w500
         )),
         TextSpan(text: " de la mejor manera")
       ]
     )),
   );
  }
}