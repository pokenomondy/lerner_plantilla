import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';
import 'package:lerner_plantilla/Pages/Vistas/VistaContenido.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Objetos/Contenido.dart';
import '../Objetos/Subtemas.dart';
import '../Objetos/Temas.dart';

class Temario extends StatefulWidget {

  @override
  _TemarioState createState() => _TemarioState();
}

class _TemarioState extends State<Temario> {
  //variables
  final db = FirebaseFirestore.instance; //inicializar firebase
  List<Temas> temasList = [];


  @override
  void initState() {
    super.initState();
  }


  Future obtenerTemasDesdeFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_listatemas') ??
        false;
    if (!datosDescargados) {
      CollectionReference referenceTemas = FirebaseFirestore.instance
          .collection("MATERIAS").doc(Config.Tema_app).collection("TEMAS");
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

        //guardar temas en shared preferences
        Temas tema = Temas(nombreTema, ordenTema, subtemasList);
        temasList.add(tema);
        print("temalist $temasList");
      }
      return temasList;
    } else {

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: obtenerTemasDesdeFirebase(),
              builder: (context,snapshot){
                List<Temas> temaslist = snapshot.data;
                return Container(
                  height: 600,
                  child: ListView.builder(
                    itemCount: temaslist.length,
                    itemBuilder: (context, index) {
                      Temas tema = temaslist[index];
                      return Column(
                        children: [
                          Container(
                            height: 40,
                            child: ListTile(
                              title: Text("${tema.ordentema} . ${tema.nombreTema}"),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: tema.subtemas.length,
                            itemBuilder: (context, subIndex) {
                              SubTemas subtema = tema.subtemas[subIndex];
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: GestureDetector(
                                  onTap: (){
                                    print(subtema.nombreSubTema);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  VistaContenido(contenidos: subtema.contenidos),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Text("${tema.ordentema}.${subtema.ordenSubtema}.${subtema.nombreSubTema}"),
                                      ],
                                    ),
                                  )
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );

              }

    ),
        ],
      ),

    );
  }


}