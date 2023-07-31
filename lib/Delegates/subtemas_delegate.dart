import 'package:flutter/material.dart';
import '../Config/config_general.dart';
import '../Objetos/Temas.dart';
import '../Objetos/Subtemas.dart';
import '../Pages/Vistas/VistaContenido.dart';

class SearchDelegateSubtemas extends SearchDelegate {
  late List<Temas> temario;

  @override
  String get searchFieldLabel => 'Buscar subtemas';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = '',
          icon: const Icon(
            Icons.clear,
            color: Config.secondColor,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Config.secondColor,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<SubTemas> subtemas = [];

    for(int index=0; index<temario.length; index++){
      if(temario[index].subtemas.isNotEmpty){
        for(int subindex=0; subindex<temario[index].subtemas.length; subindex++){
          if(temario[index].subtemas[subindex].nombreSubTema.toLowerCase().contains(query.toLowerCase())){
            subtemas.add(temario[index].subtemas[subindex]);
          }
        }
      }
    }

    if(subtemas.isNotEmpty){
      return _TarjetasDeSubtemas(subtemario: subtemas);
    }else{
      return const _NoEncontrada();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: Config().obtenerTemasDesdeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 4,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Ups! Ha ocurrido un error",
              style: Config().aplicarEstilo(Config.secondColor, 20, true));
        } else {
          temario = snapshot.data;
        }

        List<SubTemas> subtemas = [];

        for(int index=0; index<temario.length; index++){
          if(temario[index].subtemas.isNotEmpty){
            for(int subindex=0; subindex<temario[index].subtemas.length; subindex++){
              if(temario[index].subtemas[subindex].nombreSubTema.toLowerCase().contains(query.toLowerCase())){
                subtemas.add(temario[index].subtemas[subindex]);
              }
            }
          }
        }

        if(subtemas.isNotEmpty){
          return _TarjetasDeSubtemas(subtemario: subtemas);
        }else{
          return const _NoEncontrada();
        }
      },
    );
  }
}

class _NoEncontrada extends StatelessWidget{
  const _NoEncontrada({
    Key?key,
  }):super(key:key);

  @override
  Widget build(BuildContext context){
    return Center(
        child: Text(
          "Busqueda no encontrada",
          style: Config().aplicarEstilo(Config.secondColor, 40, true),
          textAlign: TextAlign.center,
        )
    );
  }
}

class _TarjetasDeSubtemas extends StatefulWidget {
  final List<SubTemas> subtemario;

  const _TarjetasDeSubtemas({
    Key? key,
    required this.subtemario,
  }) : super(key: key);

  @override
  _TarjetasDeSubtemasState createState() => _TarjetasDeSubtemasState();
}

class _TarjetasDeSubtemasState extends State<_TarjetasDeSubtemas> {
  late double containerHeight = 0.0;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.subtemario.length,
          itemBuilder: (context, index){
            return _AgregarSubtema(
              subtema: widget.subtemario[index].nombreSubTema,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => VistaContenido(contenidos: widget.subtemario[index].contenidos)));
              },
            );
          }
        ),
      ],
    );
  }
}

class _AgregarSubtema extends StatefulWidget {
  final String subtema;
  final VoidCallback onTap;

  const _AgregarSubtema(
      {Key? key,
      required this.subtema,
      required this.onTap,
      })
      : super(key: key);

  @override
  _AgregarSubtemaState createState() => _AgregarSubtemaState();
}

class _AgregarSubtemaState extends State<_AgregarSubtema> {

  late bool isPressed = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        decoration: BoxDecoration(
            color: isPressed ? Colors.white : Config.secondColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [Config().aplicarSombra(0.1, 5, 7, const Offset(0, 3))],
            border: Border.all(
                color: isPressed
                    ? Config.secondColor
                    : Config.secondColor.withOpacity(0),
                width: 2)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          child: Text(
            widget.subtema,
            style: Config().aplicarEstilo(
                isPressed ? Config.secondColor : Colors.white,
                17,
                false),
          ),
        ),
      ),
    );
  }
}
