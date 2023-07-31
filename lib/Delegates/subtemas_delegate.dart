import 'package:flutter/material.dart';
import '../Config/config_general.dart';
import '../Objetos/Temas.dart';

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
    return const Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: Config().obtenerTemasDesdeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        } else if (snapshot.hasError) {
          return Text("Ups! Ha ocurrido un error",
              style: Config().aplicarEstilo(Config.secondColor, 20, true));
        } else {
          temario = snapshot.data;
        }
        return _TarjetasDeSubtemas(temario: temario);
      },
    );
  }
}

class _TarjetasDeSubtemas extends StatefulWidget {
  final List<Temas> temario;

  const _TarjetasDeSubtemas({
    Key? key,
    required this.temario,
  }) : super(key: key);

  @override
  _TarjetasDeSubtemasState createState() => _TarjetasDeSubtemasState();
}

class _TarjetasDeSubtemasState extends State<_TarjetasDeSubtemas> {
  late Map<String, int> selectedIndexValue = {'index': -1, 'subindex': -1};
  late bool isPressed;
  late double containerHeight = 0.0;

  void _enviarASubtema(subtema){
    Navigator.pushNamed(context, '');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.temario.length,
          itemBuilder: (context, index) {
            List<Widget> subtemas = [];
            if (index != widget.temario.length) {
              if (widget.temario[index].subtemas.isNotEmpty) {
                for (int subindex = 0;
                    subindex < widget.temario[index].subtemas.length;
                    subindex++) {
                  isPressed = (selectedIndexValue['index'] == index && selectedIndexValue['subindex'] == subindex);
                  subtemas.add(_AgregarSubtema(
                    subtema:
                        widget.temario[index].subtemas[subindex].nombreSubTema,
                    isPressed: isPressed,
                    onTap: () {
                      setState(() {
                        if (selectedIndexValue['index'] == index && selectedIndexValue['subindex'] == subindex) {
                          selectedIndexValue['index'] = -1;
                          containerHeight = 0.0;
                        } else {
                          selectedIndexValue['index'] = index;
                          selectedIndexValue['subindex'] = subindex;
                          containerHeight = 1;
                        }
                      });
                    },
                  ));
                }
                return Column(
                  children: subtemas,
                );
              }
            }
            return null;
          },
        ),
        if(selectedIndexValue['index']!=-1)
        _IrASubtema(subtema: selectedIndexValue, containerHeight: containerHeight),
      ],
    );
  }
}

class _IrASubtema extends StatefulWidget{
  final Map<String, int> subtema;
  final double containerHeight;
  
  const _IrASubtema({
    Key?key,
    required this.subtema,
    required this.containerHeight
  }):super(key:key);
  
  @override
  _IrASubtemaState createState() => _IrASubtemaState();
}

class _IrASubtemaState extends State<_IrASubtema>{
  @override
  Widget build(BuildContext context){
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: (){},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            transform: Matrix4.translationValues(0.0, widget.containerHeight, 0.0),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                border: Border.all(color: Config.secondColor, width: 3),
                boxShadow: [
                  Config().aplicarSombra(0.5, 5, 7, const Offset(0, 3))
                ]),
            child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  "Ir al subtema",
                  style:
                  Config().aplicarEstilo(Config.secondColor, 25, true),
                )),
          ),
        ));
  }
}


class _AgregarSubtema extends StatefulWidget {
  final String subtema;
  final bool isPressed;
  final VoidCallback onTap;

  const _AgregarSubtema(
      {Key? key,
      required this.subtema,
      required this.isPressed,
      required this.onTap})
      : super(key: key);

  @override
  _AgregarSubtemaState createState() => _AgregarSubtemaState();
}

class _AgregarSubtemaState extends State<_AgregarSubtema> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        decoration: BoxDecoration(
            color: widget.isPressed ? Colors.white : Config.secondColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [Config().aplicarSombra(0.1, 5, 7, const Offset(0, 3))],
            border: Border.all(
                color: widget.isPressed
                    ? Config.secondColor
                    : Config.secondColor.withOpacity(0),
                width: 2)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          child: Text(
            widget.subtema,
            style: Config().aplicarEstilo(
                widget.isPressed ? Config.secondColor : Colors.white,
                17,
                false),
          ),
        ),
      ),
    );
  }
}
