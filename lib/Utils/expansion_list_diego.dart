import 'package:flutter/material.dart';
import '../Config/config_general.dart';

class ExpansionListLernen extends StatefulWidget{
  final String tittle, dificultad, universidad;
  final List<String> subtemario;
  final VoidCallback onTap;

  const ExpansionListLernen({
    Key?key,
    required this.tittle,
    required this.dificultad,
    required this.universidad,
    required this.subtemario,
    required this.onTap,
  }):super(key:key);

  @override
  ExpansionListLernenState createState() => ExpansionListLernenState();
}

class ExpansionListLernenState extends State<ExpansionListLernen>{

  late bool isPressed = false;

  @override
  Widget build(BuildContext context){

    final currentwidth = MediaQuery.of(context).size.width;
    final Color cardColor = obtenerColor(widget.dificultad);

    List<Widget> subtemas = [];
    subtemas.add(Padding(padding: const EdgeInsets.only(bottom: 5),child: Text("Temas necesarios:", style: Config().aplicarEstilo(Colors.white, 13, true),)));

    for(int i=0; i<widget.subtemario.length; i++){
      if(widget.subtemario[i].isNotEmpty){
        subtemas.add(Padding(padding: const EdgeInsets.only(left: 10),child: Text(widget.subtemario[i], style: Config().aplicarEstilo(Colors.white, 13, false),)));
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                isPressed = !isPressed;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [Config().aplicarSombra(0.1, 3, 7, const Offset(0, 4))],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardColor, width: 3)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 15, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.tittle, style: Config().aplicarEstilo(cardColor, 16, true)),
                        Text(widget.universidad, style: Config().aplicarEstilo(Config.grayColor, 14, false),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 5),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),

                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      alignment: Alignment.center,
                      child: Text(widget.dificultad, style: Config().aplicarEstilo(Colors.white, 12, true),),
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: isPressed ? Container(
              width: currentwidth - 80,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subtemas,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 7),
                      alignment: Alignment.center,
                      decoration:
                      const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(),
                        child: IconButton(
                            iconSize: 35,
                            onPressed: widget.onTap,
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Config.grayColor,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ) : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  Color obtenerColor(dificultad){
    if(dificultad=="Facil"){
      return Config.greenColorParcial;
    }else if(dificultad=="Intermedio"){
      return Config.secondColor;
    }else{
      return Config.contrastColor;
    }
  }

}
