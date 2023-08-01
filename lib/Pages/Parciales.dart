import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/config_general.dart';
import 'package:lerner_plantilla/Utils/expansion_list_diego.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Objetos/Parciales.dart';
import 'Vistas/VistaContenido.dart';

class Parcialesvista extends StatefulWidget {
  const Parcialesvista({super.key});

  @override
  _ParcialesvistaState createState() => _ParcialesvistaState();
}

class _ParcialesvistaState extends State<Parcialesvista> {
  List<Parciales> parcialesList = [];
  Config config = Config();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Config().defaultAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: config.obtenerParcialesDesdeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Mientras se espera, mostrar un mensaje de carga
                  return const Center(
                    child:
                        CircularProgressIndicator(), // O cualquier otro widget de carga
                  );
                } else if (snapshot.hasError) {
                  // Si ocurre un error en el Future, mostrar un mensaje de error
                  return const Center(
                    child: Text("Error al cargar los datos"),
                  );
                } else {
                  List<Parciales> parcialesList = snapshot.data;

                  return CuadroParciales(parcialesList);
                }
              }),
        ],
      ),
    );
  }
}

class CuadroParciales extends StatefulWidget {
  final List<Parciales> parcialesList;

  const CuadroParciales(this.parcialesList);

  @override
  CuadroParcialesState createState() => CuadroParcialesState();
}

class CuadroParcialesState extends State<CuadroParciales> {

  @override
  Widget build(BuildContext context) {
    final double currentheight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: currentheight - 140,
        child: Padding(
          padding: EdgeInsets.zero,
          child: ListView.builder(
              shrinkWrap: true,
              padding: MediaQuery.of(context).padding.copyWith(
                    left: 0,
                    right: 0,
                    bottom: 50,
                  ),
              itemCount: widget.parcialesList.length,
              itemBuilder: (context, index) {
                Parciales parcial = widget.parcialesList[index];

                return ExpansionListLernen(
                    tittle: parcial.fraseparcial,
                    dificultad: parcial.indicedificultad,
                    universidad: parcial.universidad,
                    subtemario: parcial.subtemas,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VistaContenido(
                            contenidos: parcial.contenidos,
                          ),
                        ),
                      );
                    } //Aqui enviar a pestaña del parcial
                    );
              }),
        ),
      ),
    );
  }
}
