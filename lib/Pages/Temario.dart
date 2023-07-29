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


  Future obtenerTemasDesdeFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temasJson = prefs.getString('temas_list') ?? '';
    List<dynamic> temasData = jsonDecode(temasJson);
    List temasList = temasData.map((temaData) => Temas.fromJson(temaData)).toList();

    return temasList;
  }

  @override
  Widget build(BuildContext context) {
    final currentwidth = MediaQuery.of(context).size.width;
    final currentheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primary_color,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Aquí puedes agregar la lógica para realizar la búsqueda
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: obtenerTemasDesdeFirebase(),
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

                  return Container(
                    height: currentheight-100,

                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: temaslist.length,
                      itemBuilder: (context, index) {
                        Temas tema = temaslist[index];

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              CuadroTema(tema,temaslist),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }

          ),
        ],
      ),

    );
  }


}

class CuadroTema extends StatefulWidget{
  final Temas tema;
  final List<Temas> temasList;

  CuadroTema(this.tema, this.temasList,);

  @override
  _CuadroTemaState createState() => _CuadroTemaState();
}


class _CuadroTemaState extends State<CuadroTema> {
  List<bool> _isExpandedList = [];


  @override
  void initState() {
    super.initState();
    print(_isExpandedList);
    /*
    print("numero retornado ${widget.temasList.length}");

     */
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cuadoTemaestilo(),
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (i, isExpanded) {
          setState(() {
            _isExpandedList[i] = !isExpanded; // Cambiar el estado del panel al hacer clic en el encabezado
            print(_isExpandedList);
            print(i);
          });
        },
        children: [
        ExpansionPanel(
        hasIcon: false,
        canTapOnHeader: true,
        headerBuilder: (context, isOpen) {
          return Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.tema.ordentema} . ${widget.tema.nombreTema}", style: estilotexto(),),
                      Text('## subtemas'),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Texto careverga adciional'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        body: Text('asasasa'),
      ),
        ],
      ),
    );
  }

  estilotexto(){
    return TextStyle(
        fontWeight: FontWeight.w500,
        color: Config.primary_color,
        fontSize: 18,
        fontFamily:"Poppins");
  }

  cuadoTemaestilo() {
    return BoxDecoration(
      color: Config.white_color,
      borderRadius: BorderRadius.circular(50.0),

    );
  }
}
