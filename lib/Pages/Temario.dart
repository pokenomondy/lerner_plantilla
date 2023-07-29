import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: ListView.builder(
        itemCount: widget.temaslist.length,
        itemBuilder: (context, index) {
          Temas tema = widget.temaslist[index];

          return Column(
            children: [

              ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: CuadroTemaDiseno(),
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textotituloTema("${tema.ordentema}.${tema.nombreTema}"),
                                Text('## subtemas'),
                            ],)
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
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "${tema.ordentema}.${subtema.ordenSubtema}.${subtema.nombreSubTema}",
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  textotituloTema(String texto){
    return Text(texto,style: TextStyle(fontWeight: FontWeight.bold,color: Config.primary_color),);
  }

  CuadroTemaDiseno() {
    return BoxDecoration(
      color: Config.white_color,
      borderRadius: BorderRadius.circular(20.0),

    );
  }

}


