import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lerner_plantilla/Config/config_general.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Objetos/Parciales.dart';


class Parcialesvista extends StatefulWidget {
  @override
  _ParcialesvistaState createState() => _ParcialesvistaState();
}

class _ParcialesvistaState extends State<Parcialesvista> {
  List<Parciales> parcialesList = [];



  Future obtenerParcialesDesdeFirebase() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_parciales') ?? false;
    if(!datosDescargados){
      CollectionReference referenceParciales = FirebaseFirestore.instance.collection("PARCIALES").doc(Config.temaApp).collection("PARCIALES");
      QuerySnapshot queryParciales = await referenceParciales.get();

      for(var parcialDoc in queryParciales.docs){
        String fraseParcial = parcialDoc['fraseparcial'];
        String universidad = parcialDoc['universidad'];
        String materia = parcialDoc['materia'];
        List<dynamic> temaDynamic = parcialDoc['tema'];
        List<dynamic> subtemasDynamic = parcialDoc['subtemas'];
        List<String> tema = temaDynamic.cast<String>();
        List<String> subtemas = subtemasDynamic.cast<String>();
        String indicedificultad = parcialDoc['indicedificultad'];
        print("$fraseParcial,$universidad,$materia");

        Parciales newparcial = Parciales(fraseParcial, universidad, materia, tema, subtemas, indicedificultad);
        parcialesList.add(newparcial);
      }

      return parcialesList;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: obtenerParcialesDesdeFirebase(),
              builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Mientras se espera, mostrar un mensaje de carga
                  return Center(
                    child: CircularProgressIndicator(), // O cualquier otro widget de carga
                  );
                } else if (snapshot.hasError) {
                  // Si ocurre un error en el Future, mostrar un mensaje de error
                  return Center(
                    child: Text("Error al cargar los datos"),
                  );
                } else {
                  List<Parciales> parcialesList = snapshot.data;

                  return CuadroParciales(parcialesList);

                }
              }
              ),
        ],
      ),
    );
  }
}

class CuadroParciales extends StatefulWidget {
  final List<Parciales> parcialesList;


  CuadroParciales(this.parcialesList);

  @override
  _CuadroParcialesState createState() => _CuadroParcialesState();
}

class _CuadroParcialesState extends State<CuadroParciales> {
  int? _expandedIndex;


  @override
  Widget build(BuildContext context) {
    final double currentwidth = MediaQuery.of(context).size.width;
    final double currentheight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Container(
        height: currentheight-100,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ListView.builder(
              shrinkWrap: true,
              padding: MediaQuery.of(context).padding.copyWith(
                left: 0,
                right: 0,
                bottom: 50,
              ),
              itemCount: widget.parcialesList.length,
              itemBuilder: (context,index){
                Parciales parcial = widget.parcialesList[index];
                bool isExpanded = index ==  _expandedIndex;

                return Column(
                  children: [
                    Container(
                      decoration: cuadroParcialDiseno(parcial.indicedificultad,isExpanded,"carta principal"),
                      child:ExpansionTile(
                        onExpansionChanged: (expanded){
                          setState(() {
                            _expandedIndex = expanded ? index : null;
                          });
                        },
                        title: Container(
                          decoration: cuadroParcialDiseno(parcial.indicedificultad,isExpanded,"carta principal"),
                          height: 100,
                          child: Padding(
                              padding: EdgeInsets.zero,
                              child: Container(
                                height: 60,
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(parcial.fraseparcial,style: textocuadros(parcial.indicedificultad,"as")),
                                          Container(
                                              width: 90,
                                              decoration: cuadroParcialDiseno(parcial.indicedificultad,isExpanded,"indificultad"),
                                              child: Center(
                                                child: Text(parcial.indicedificultad,style: textocuadros(parcial.indicedificultad,"indificultad"),
                                                ),
                                              )),
                                        ],),
                                      Text(parcial.universidad),

                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                        children: isExpanded
                            ? [ ListTileTheme(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: cuadrosubtemasdiseno(parcial.indicedificultad), // Personaliza el color como desees
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: currentwidth/2+100,
                                  height: 180,
                                  color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Temas necesarios',style: textocuadros(parcial.indicedificultad, "indificultad"),),
                                      ListTileTheme(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: parcial.subtemas.length,
                                          itemBuilder: (context, subIndex) =>
                                              Row(
                                                children: [
                                                  Text(parcial.subtemas[subIndex],style: textocuadros(parcial.indicedificultad, "indificultad"),),
                                                ],
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),]
                            : [],
                      ),
                    ),
                  ],
                );

              }
          ),
        ),
      ),
    );
  }

  cuadroParcialDiseno(String indicedificultad, bool isExpanded, String tipodecuadro){
    Color color;
    Color colorfondo;
    if(indicedificultad=="Intermedio"){
      color = Config.greenColorParcial;
    }else if(indicedificultad=="Facil"){
      color = Config.primaryColor;
    }else{ //Dificil
      color = Config.redColorParcial;
    }

    if(tipodecuadro=="indificultad"){
      colorfondo = color;
    }else{
      colorfondo = Config.whiteColor;
    }

    return BoxDecoration(
      color: colorfondo,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: color,
        width: 2,
      ),
    );

  }

  textocuadros(String indicedificultad, String tipodecuadro){
    Color color;
    double fontSize = 15;

    if(tipodecuadro=="indificultad"){
      color = Config.whiteColor;
      fontSize = 12;
    }else{
      if(indicedificultad=="Intermedio"){
        color = Config.greenColorParcial;
      }else if(indicedificultad=="Facil"){
        color = Config.primaryColor;
      }else{ //Dificil
        color = Config.redColorParcial;
      }
    }



    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: "Poppins",
    );
  }

  cuadrosubtemasdiseno(String indicedificultad){
    Color color;
    if(indicedificultad=="Intermedio"){
      color = Config.greenColorParcial;
    }else if(indicedificultad=="Facil"){
      color = Config.primaryColor;
    }else{ //Dificil
      color = Config.redColorParcial;
    }

    return BoxDecoration(
      color: color,
    );
  }


}