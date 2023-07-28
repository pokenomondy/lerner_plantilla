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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.colorPrincipal,
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
                                title: Text(
                                    "${tema.ordentema} . ${tema.nombreTema}"),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tema.subtemas.length,
                              itemBuilder: (context, subIndex) {
                                SubTemas subtema = tema.subtemas[subIndex];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        print(subtema.nombreSubTema);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VistaContenido(
                                                    contenidos: subtema
                                                        .contenidos),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Text("${tema.ordentema}.${subtema
                                                .ordenSubtema}.${subtema
                                                .nombreSubTema}"),
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
              }

    ),
        ],
      ),

    );
  }




}