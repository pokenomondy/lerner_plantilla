import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/embeds/builders.dart';
import 'package:intl/intl.dart';

import '../../Objetos/Contenido.dart';
import '../../Widgets/FirebaseImageWidget.dart';
import '../../Widgets/LatexEmbedBuilder.dart';


class VistaContenido extends StatefulWidget {
  final List<Contenido> contenidos;

  VistaContenido({required this.contenidos});

  @override
  _VistaContenidoState createState() => _VistaContenidoState();
}

class _VistaContenidoState extends State<VistaContenido> {
  QuillController _controller = QuillController.basic();
  List<Map<String, dynamic>> contenidoData = [];



  @override
  void initState() {
    super.initState();
    cargarcontenido();
  }

  Future<void> cargarcontenido() async {

    final contenido = widget.contenidos[0].contenido;
    print("pruebas contenido putamadre");
    print(contenido);
    final delta = Delta.fromJson(contenido as List);
    _controller.compose(delta, TextSelection.collapsed(offset: 0), ChangeSource.LOCAL);



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: true,
              embedBuilders: [
                FirebaseImageEmbedBuilder(),
                VideoEmbedBuilder(),
                LatexEmbedBuilder(),
              ],
            ),
          ),
        ],
      ),
    );
  }




}