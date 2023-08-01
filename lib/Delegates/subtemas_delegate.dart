import 'package:flutter/material.dart';
import '../Config/config_general.dart';
import '../Objetos/Parciales.dart';
import '../Objetos/Temas.dart';
import '../Pages/Vistas/VistaContenido.dart';

class SearchDelegateSubtemas extends SearchDelegate {
  late List<Temas> temario;
  late List<Map<String, dynamic>> items;
  late int selectedOpcion = 1;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        appBarTheme: const AppBarTheme(
          color: Config.secondColor,
          elevation: 4.0,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 15)));
  }

  @override
  String get searchFieldLabel => 'Buscar temas y parciales';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(top: 11, bottom: 11, right: 7),
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: IconButton(
            iconSize: 20,
            onPressed: () => query = '',
            icon: const Icon(
              Icons.clear,
              color: Config.grayColor,
            )),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 11, bottom: 11),
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: IconButton(
            iconSize: 20,
            onPressed: () => close(context, null),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Config.grayColor,
            )),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<dynamic> itemsBuscados = [];

    for (int recorrer = 0; recorrer < items.length; recorrer++) {
      if (items[recorrer]['esSubtema'] && (selectedOpcion == 2 || selectedOpcion == 1)) {
        temario = items[recorrer]['Content'];
        for (int index = 0; index < temario.length; index++) {
          if (temario[index].subtemas.isNotEmpty) {
            for (int subindex = 0;
            subindex < temario[index].subtemas.length;
            subindex++) {
              if (temario[index]
                  .subtemas[subindex]
                  .nombreSubTema
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                itemsBuscados.add(temario[index].subtemas[subindex]);
              }
            }
          }
        }
      } else if(!items[recorrer]['esSubtema'] && (selectedOpcion == 3 || selectedOpcion == 1)){
        List<Parciales> parciales = items[recorrer]['Content'];
        for (int index = 0; index < parciales.length; index++) {
          if (parciales[index]
              .fraseparcial
              .toLowerCase()
              .contains(query.toLowerCase())) {
            itemsBuscados.add(parciales[index]);
          }
        }
      }
    }

    itemsBuscados.sort((a,b){
      if(a.runtimeType.toString() == "SubTemas" && b.runtimeType.toString() == "SubTemas"){
        return a.nombreSubTema.toLowerCase().compareTo(b.nombreSubTema.toLowerCase());
      }else if(a.runtimeType.toString() == "SubTemas" && b.runtimeType.toString() == "Parciales"){
        return a.nombreSubTema.toLowerCase().compareTo(b.fraseparcial.toLowerCase());
      } else if(a.runtimeType.toString() == "Parciales" && b.runtimeType.toString() == "SubTemas"){
        return a.fraseparcial.toLowerCase().compareTo(b.nombreSubTema.toLowerCase());
      } else{
        return a.fraseparcial.toLowerCase().compareTo(b.fraseparcial.toLowerCase());
      }
    });

    if (itemsBuscados.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 10),
            child: Row(
              children: [
                _OpcionesFiltrado(titulo: "Todos", isPressed: selectedOpcion == 1, onTap: (){
                  selectedOpcion = 1;
                  query = query;
                  showResults(context);
                }),
                _OpcionesFiltrado(titulo: "Temas", isPressed: selectedOpcion == 2, onTap: (){
                  if(selectedOpcion == 2){
                    selectedOpcion = 1;
                    query = query;
                    showResults(context);
                  }else{
                    selectedOpcion = 2;
                    query = query;
                    showResults(context);
                  }
                }),
                _OpcionesFiltrado(titulo: "Parciales", isPressed: selectedOpcion == 3, onTap: (){
                  if(selectedOpcion == 3){
                    selectedOpcion = 1;
                    query = query;
                    showResults(context);
                  }else{
                    selectedOpcion = 3;
                    query = query;
                    showResults(context);
                  }
                })
              ],
            ),
          ),
          Expanded(child: _TarjetasDeBusqueda(items: itemsBuscados))
        ],
      );
    } else {
      return const _NoEncontrada();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 22, bottom: 10),
            child: Row(
              children: [
                  _OpcionesFiltrado(titulo: "Todos", isPressed: selectedOpcion == 1, onTap: (){
                    selectedOpcion = 1;
                    showResults(context);
                  }),
                  _OpcionesFiltrado(titulo: "Temas", isPressed: selectedOpcion == 2, onTap: (){
                    if(selectedOpcion == 2){
                      selectedOpcion = 1;
                      showResults(context);
                    }else{
                      selectedOpcion = 2;
                      showResults(context);
                    }
                  }),
                _OpcionesFiltrado(titulo: "Parciales", isPressed: selectedOpcion == 3, onTap: (){
                  if(selectedOpcion == 3){
                    selectedOpcion = 1;
                    showResults(context);
                  }else{
                    selectedOpcion = 3;
                    showResults(context);
                  }
                })
              ],
            ),
        ),
        Expanded(
            child: FutureBuilder(
              future: Config().obtenerDatosBuscador(),
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
                  items = snapshot.data!;
                }

                List<dynamic> itemsBuscados = [];

                for (int recorrer = 0; recorrer < items.length; recorrer++) {
                  if (items[recorrer]['esSubtema'] && (selectedOpcion == 2 || selectedOpcion == 1)) {
                    temario = items[recorrer]['Content'];
                    for (int index = 0; index < temario.length; index++) {
                      if (temario[index].subtemas.isNotEmpty) {
                        for (int subindex = 0;
                        subindex < temario[index].subtemas.length;
                        subindex++) {
                          if (temario[index]
                              .subtemas[subindex]
                              .nombreSubTema
                              .toLowerCase()
                              .contains(query.toLowerCase())) {
                            itemsBuscados.add(temario[index].subtemas[subindex]);
                          }
                        }
                      }
                    }
                  } else if(!items[recorrer]['esSubtema'] && (selectedOpcion == 3 || selectedOpcion == 1)){
                    List<Parciales> parciales = items[recorrer]['Content'];
                    for (int index = 0; index < parciales.length; index++) {
                      if (parciales[index]
                          .fraseparcial
                          .toLowerCase()
                          .contains(query.toLowerCase())) {
                        itemsBuscados.add(parciales[index]);
                      }
                    }
                  }
                }

                itemsBuscados.sort((a,b){
                  if(a.runtimeType.toString() == "SubTemas" && b.runtimeType.toString() == "SubTemas"){
                    return a.nombreSubTema.toLowerCase().compareTo(b.nombreSubTema.toLowerCase());
                  }else if(a.runtimeType.toString() == "SubTemas" && b.runtimeType.toString() == "Parciales"){
                    return a.nombreSubTema.toLowerCase().compareTo(b.fraseparcial.toLowerCase());
                  } else if(a.runtimeType.toString() == "Parciales" && b.runtimeType.toString() == "SubTemas"){
                    return a.fraseparcial.toLowerCase().compareTo(b.nombreSubTema.toLowerCase());
                  } else{
                    return a.fraseparcial.toLowerCase().compareTo(b.fraseparcial.toLowerCase());
                  }
                });


                if (itemsBuscados.isNotEmpty) {
                  return _TarjetasDeBusqueda(items: itemsBuscados);
                } else {
                  return const _NoEncontrada();
                }
              },
            ))
      ],
    );
  }
}

class _OpcionesFiltrado extends StatefulWidget{

  final String titulo;
  final bool isPressed;
  final VoidCallback onTap;

  const _OpcionesFiltrado({
    Key?key,
    required this.titulo,
    required this.isPressed,
    required this.onTap
  }):super(key:key);

  @override
  _OpcionesFiltradoState createState() => _OpcionesFiltradoState();

}

class _OpcionesFiltradoState extends State<_OpcionesFiltrado>{

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: widget.isPressed? Config.secondColor : Config.grayColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Text(widget.titulo, style: Config().aplicarEstilo(widget.isPressed? Colors.white : Config.grayColor, 14, true),),
        ),
      ),
    );
  }

}

class _NoEncontrada extends StatelessWidget {
  const _NoEncontrada({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Busqueda no encontrada",
      style: Config().aplicarEstilo(Config.secondColor, 40, true),
      textAlign: TextAlign.center,
    ));
  }
}

class _TarjetasDeBusqueda extends StatefulWidget {
  final List<dynamic> items;

  const _TarjetasDeBusqueda({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _TarjetasDeBusquedaState createState() => _TarjetasDeBusquedaState();
}

class _TarjetasDeBusquedaState extends State<_TarjetasDeBusqueda> {
  late double containerHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          if (widget.items[index].runtimeType.toString() == "SubTemas") {
            return _AgregarSubtema(
              subtema: widget.items[index].nombreSubTema,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VistaContenido(
                            contenidos: widget.items[index].contenidos)));
              },
            );
          } else {
            return _AgregarParcial(
                tittleParcial: widget.items[index].fraseparcial,
                dificultad: widget.items[index].indicedificultad,
                onTap: () {});
          }
        });
  }
}

class _AgregarSubtema extends StatefulWidget {
  final String subtema;
  final VoidCallback onTap;

  const _AgregarSubtema({
    Key? key,
    required this.subtema,
    required this.onTap,
  }) : super(key: key);

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
        margin: const EdgeInsets.only(top: 11, left: 10, right: 10),
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        decoration: BoxDecoration(
            color: isPressed ? Config.secondColor : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [Config().aplicarSombra(0.1, 5, 7, const Offset(0, 3))],
            border: Border.all(
                color: isPressed
                    ? Config.secondColor.withOpacity(0)
                    : Config.secondColor,
                width: 2.5)),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.subtema,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: isPressed ? Colors.white : Config.secondColor,
                      fontWeight: FontWeight.w500,
                      height: 1)),
              Text(
                "Tema",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: isPressed ? Colors.white : Config.grayColor,
                    fontWeight: FontWeight.w300,
                    height: 1.3),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AgregarParcial extends StatefulWidget {
  final String tittleParcial, dificultad;
  final VoidCallback onTap;

  const _AgregarParcial(
      {Key? key,
      required this.tittleParcial,
      required this.dificultad,
      required this.onTap})
      : super(key: key);

  @override
  _AgregarParcialState createState() => _AgregarParcialState();
}

class _AgregarParcialState extends State<_AgregarParcial> {
  late bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color cardColor = obtenerColor(widget.dificultad);
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
        margin: const EdgeInsets.only(top: 11, left: 10, right: 10),
        duration: const Duration(milliseconds: 400),
        width: double.infinity,
        decoration: BoxDecoration(
            color: isPressed ? cardColor : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [Config().aplicarSombra(0.1, 5, 7, const Offset(0, 3))],
            border: Border.all(
                color:
                    isPressed ? Config.secondColor.withOpacity(0) : cardColor,
                width: 2.5)),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.tittleParcial,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: isPressed ? Colors.white : cardColor,
                      fontWeight: FontWeight.w500,
                      height: 1)),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Text(
                      "Parcial",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: isPressed ? Colors.white : Config.grayColor,
                          fontWeight: FontWeight.w300,
                          height: 1.3),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isPressed? Colors.white: cardColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(widget.dificultad,
                          style: Config().aplicarEstilo(isPressed? cardColor: Colors.white, 12, true),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color obtenerColor(dificultad) {
    if (dificultad == "Facil") {
      return Config.greenColorParcial;
    } else if (dificultad == "Intermedio") {
      return Config.secondColor;
    } else {
      return Config.contrastColor;
    }
  }
}
