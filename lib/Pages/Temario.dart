import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/config_general.dart';
import 'package:lerner_plantilla/Pages/Vistas/VistaContenido.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Objetos/Temas.dart';


class Temario extends StatefulWidget {

  @override
  _TemarioState createState() => _TemarioState();

}

class _TemarioState extends State<Temario> {
  //variables
  final db = FirebaseFirestore.instance; //inicializar firebase
  List<Temas> temasList = [];
  Config config = Config();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config().defaultAppBar(),
      body: Column(
        children: [
          FutureBuilder(
              future: config.obtenerTemasDesdeFirebase(),
              builder: (context,snapshot) {
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
                  List<Temas> temaslist = snapshot.data;

                  return CuadroTema(temaslist);
                }
              }

          ),
        ],
      ),

    );
  }

}

class CuadroTema extends StatefulWidget {
  final List<Temas> temaslist;


  CuadroTema(this.temaslist);

  @override
  _CuadroTemaState createState() => _CuadroTemaState();
}

class _CuadroTemaState extends State<CuadroTema> {
  int? _expandedIndex; // Rastrea el índice del tema expandido


  @override
  Widget build(BuildContext context) {
    final double currentheight = MediaQuery.of(context).size.height;

    return Container(
      height: currentheight-100,
      child: ListView.builder(
        itemCount: widget.temaslist.length,
        itemBuilder: (context, index) {
          Temas tema = widget.temaslist[index];
          //estado de expandido
          bool isExpanded = index == _expandedIndex;

          return Column(
            children: [
              Container(
                child: ExpansionTile(
                  onExpansionChanged: (expanded){
                    setState(() {
                      _expandedIndex = expanded ? index : null;
                      print(_expandedIndex);
                      print(isExpanded);
                    });
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                    child: Container(
                        decoration: CuadroTemaDiseno(isExpanded),
                        height: 90,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textotituloTema("${tema.ordentema}. ${tema.nombreTema}"),
                                  textoAuxiliarTema('${tema.subtemas.length} subtemas'),
                                ],),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  children: tema.subtemas.map((subtema) {
                    return GestureDetector(
                      onTap: () {
                        print(subtema.nombreSubTema);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VistaContenido(
                              contenidos: subtema.contenidos,
                              titulo: '${tema.ordentema}.${subtema.ordenSubtema} ${subtema.nombreSubTema}',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                        child: Container(
                          margin: EdgeInsets.only(left: 50,right: 30),
                          decoration: CuadroSubTemaDiseno(),
                          height: 56,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          textotituloSubTema("${tema.ordentema}.${subtema.ordenSubtema}.${subtema.nombreSubTema}"),
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: textotituloSubTema(''),)
                                        ],
                                      ),
                                      Icon(Icons.not_started,color: Config.whiteColor, size: 40,)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  textotituloTema(String texto){
    return Text(texto,style: TextStyle(fontWeight: FontWeight.bold,color: Config.primaryColor,fontFamily: "Poppins",fontSize: 14),);
  }

  textoAuxiliarTema(String texto){
    return Text(texto,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontFamily: "Poppins",fontSize: 10),);
  }

  textotituloSubTema(String texto){
    return Text(texto,style: TextStyle(color: Config.whiteColor,fontFamily: "Poppins",fontSize: 11),);
  }


  CuadroTemaDiseno(bool isExpanded) {
    return BoxDecoration(
      boxShadow: [BoxShadow(
          color: Config.grayColor.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 7,
          offset: const Offset(0, 4),
      )],
      color: Config.whiteColor,
      borderRadius: BorderRadius.circular(20.0),
      border: isExpanded ? Border.all(color: Config.primaryColor, width: 2.0) : Border(),

    );
  }

  CuadroSubTemaDiseno() {
    return BoxDecoration(
      boxShadow: [BoxShadow(
        color: Config.grayColor.withOpacity(0.1),
        spreadRadius: 3,
        blurRadius: 7,
        offset: const Offset(0, 4),
      )],
      color: Config.primaryColor,
      borderRadius: BorderRadius.circular(12.0),

    );
  }

}

