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

  @override
  void initState() {
    super.initState();
    obtenerTemasDesdeFirebase();
  }


  Future obtenerTemasDesdeFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_listatemas') ??
        false;
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
      guardardatos();
      return temasList;
    } else {
      // print('ya descargados los datos, se cargan de sharedpreferences');
    }
  }

  Future guardardatos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("se guardan datos");
    String temasJson = jsonEncode(temasList); //convertios a Json para guardar
    await prefs.setString('temas_list', temasJson); // Guardamos en shared preferecnes
    await prefs.setBool('datos_descargados_listatemas', true);
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DibujarLogo(),
            _EscribirFrase(),
            LinearProgressIndicator()
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
            height: 0.4
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