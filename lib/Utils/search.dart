import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Delegates/subtemas_delegate.dart';
import '../Objetos/Temas.dart';
import '../Config/config_general.dart';

class SearchBuild extends StatefulWidget {
  const SearchBuild({super.key});

  @override
  SearchBuildState createState() => SearchBuildState();
}

class SearchBuildState extends State<SearchBuild> {
  @override
  Widget build(BuildContext context) {

    final double currentwidth = MediaQuery.of(context).size.width;
    Config configuracion = Config();

    return Container(
      width: currentwidth,
      height: 100,
      decoration: BoxDecoration(color: Config.secondColor, boxShadow: [
        configuracion.aplicarSombra(0.3, 5, 7, const Offset(0, 3))
      ]),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 15, top: 15),
              child: Text("Buscador aqui..",
                  style: Config().aplicarEstilo(Colors.white, 18, true)
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: MaterialButton(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 0,
                    splashColor: Colors.transparent,
                    onPressed: (){
                      showSearch(
                          context: context,
                          delegate: SearchDelegateSubtemas()
                      );
                    },
                    child: const Icon(Icons.search, color: Config.secondColor, size: 22,)
                ),
            )
          ],
        ),
    );
  }
}