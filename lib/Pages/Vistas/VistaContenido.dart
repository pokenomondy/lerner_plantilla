import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/embeds/builders.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lerner_plantilla/Config/AdHelper.dart';
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
  InterstitialAd? _interstitialAd;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    cargarcontenido();
    _loadInterstitialAd();
  }


  Future<void> cargarcontenido() async {

    final contenido = widget.contenidos[0].contenido;
    print("pruebas contenido putamadre");
    print(contenido);
    final delta = Delta.fromJson(contenido as List);
    _controller.compose(delta, TextSelection.collapsed(offset: 0), ChangeSource.LOCAL);



  }



  void _loadInterstitialAd(){
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad){
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad){
                  print("aqui solo deberia mostrar normalmente la app");
                }
              );
              setState(() {
                _interstitialAd = ad;
                _showInterstitialAd();
              });
            },
            onAdFailedToLoad: (err){
              print('Failed to load an interstitial ad: ${err.message}');
            }
        ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      print("El anuncio intersticial no está disponible para mostrar.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double currentheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30,right: 30,bottom: 0,top: 40),
            child: Container(
              height: currentheight-40,
              child: QuillEditor(
                expands: true,
                scrollController: _scrollController,
                focusNode: _focusNode,
                scrollable: true,
                padding: EdgeInsets.all(5),
                controller: _controller,
                autoFocus: false,
                readOnly: true,
                embedBuilders: [
                  FirebaseImageEmbedBuilder(),
                  VideoEmbedBuilder(),
                  LatexEmbedBuilder(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }




}