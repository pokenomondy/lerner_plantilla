import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Objetos/Contenido.dart';
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

class _CargarDatosState extends State<_CargarDatos>{

  final db = FirebaseFirestore.instance; //inicializar firebase
  List<Temas> temasList = [];
  bool isLoading = false;
  double progressValue = 0.0;
  String progresstext = "0.0";
  bool _datosdescargados = false; //datos descargados por parte de firebase

  @override
  void initState() {
    super.initState();
    obtenerTemasDesdeFirebase();

  }

  Future obtenerTemasDesdeFirebase() async {
    startprogressindicator();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_listatemas') ?? false;
    if (!datosDescargados) {
      // print("Los datos apenas se van a descargar, priemra vez");
      CollectionReference referenceTemas = FirebaseFirestore.instance
          .collection("MATERIAS").doc(Config.Tema_app).collection("TEMAS");
      QuerySnapshot queryTemas = await referenceTemas.get();

      for (var temaDoc in queryTemas.docs) {
        String nombreTema = temaDoc['nombre Tema'];
        int ordenTema = temaDoc['Orden tema'];
        // print("$ordenTema $nombreTema");

        //Ahora metemos subtemas para crear la lista y guardar
        QuerySnapshot subtemasDocs = await temaDoc.reference.collection(
            'SUBTEMAS').get();
        List<SubTemas> subtemasList = [];
        for (var subtemaDoc in subtemasDocs.docs) {
          String nombreSubTema = subtemaDoc['nombreSubTema']; // Suponiendo que 'nombreSubTema' es el campo que contiene el nombre del subtema
          int ordenSubtema = subtemaDoc['ordenSubtema'];
          // print("$ordenSubtema $nombreSubTema");

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
            // print("contenido = $contenidoData");
          }
          //guaramos subtemas
          SubTemas subtema = SubTemas(nombreSubTema, ordenSubtema, contenidos);
          subtemasList.add(subtema);
        }

        Temas tema = Temas(nombreTema, ordenTema, subtemasList);
        temasList.add(tema);
        // print("temalist $temasList");
      }
      setState(() {
        _datosdescargados = true;
      });
      guardardatos();
      return temasList;
    } else {
      // print('ya descargados los datos, se cargan de sharedpreferences');
      setState(() {
        _datosdescargados = true;
      });
    }
  }

  void startprogressindicator() {
    setState(() {
      isLoading = true;
      progressValue = 0;
    });

    const totalProgressTime = 2; // Tiempo total para llegar al 90%
    const steps = 50; // Cantidad de pasos para el incremento

    final stepDuration = Duration(milliseconds: (totalProgressTime * 1000) ~/ steps);

    var currentStep = 0;

    Timer.periodic(stepDuration, (timer) {
      currentStep++;
      setState(() {
        progressValue = currentStep / steps * 0.9;
        progresstext = (progressValue*100).toStringAsFixed(1);
      });

      if (currentStep == steps) {
        timer.cancel();
        if (_datosdescargados) {
          completeprogress(); // Iniciar el progreso del 90% al 100%
        }
      }
    });
  }

  Future guardardatos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("se guardan datos");
    String temasJson = jsonEncode(temasList); //convertios a Json para guardar
    await prefs.setString('temas_list', temasJson); // Guardamos en shared preferecnes
    await prefs.setBool('datos_descargados_listatemas', true);
  }

  void completeprogress(){
    const completeDuration = 1000; // Tiempo para completar el 10% restante (desde el 90% hasta el 100%)
    const steps = 10; // Cantidad de pasos para el incremento

    final stepDuration = Duration(milliseconds: (completeDuration ~/ steps));
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
    print("redireccionar");
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
            colors: [Config.second_color, Colors.white.withOpacity(0)],
          ),
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DibujarLogo(),
            _EscribirFrase(),
            Container(
              width: currentwidth-180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: currentwidth-220,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: progressValue,
                              minHeight: 10,
                              valueColor: AlwaysStoppedAnimation<Color>(Config.primary_color),
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
            color: Config.second_color,
            height: 0.8
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