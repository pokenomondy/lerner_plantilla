import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Config/ConfigGeneral.dart';

class Dashboard extends StatelessWidget {

  const Dashboard({super.key});

  @override
  Widget build(BuildContext context){

    final double currentwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _Crearbuscador(currentwidth: currentwidth,),
            _CrearBoton(title: "Ver temario", subtitle: "Oprima para ver el temario \ndel area", currentwidth: currentwidth, imageRoute: 'assets/sources/temario.jpg', destinationRoute: '/home/temario',),
            _CrearBoton(title: "Hacer ejercicio", subtitle: "Ejercicios para prepararte \npara tus examenes", currentwidth: currentwidth, imageRoute: 'assets/sources/ejercicio.jpg', destinationRoute: '/home/temario',)
          ],
        ),
      ),
    );
  }

}

class _Crearbuscador extends StatelessWidget{
  const _Crearbuscador({Key?key, required this.currentwidth}): super(key:key);
  final double currentwidth;

  @override
  Widget build(BuildContext context){
    Config configuracion = Config();

    return Container(
      width: currentwidth,
      height: 80,
      decoration: BoxDecoration(
        color: Config.second_color,
        boxShadow: [configuracion.aplicarSombra(0.3, 5, 7, const Offset(0, 3))]
      ),
      child: Center(
        child: Text("Buscador aqui", style: configuracion.aplicarEstilo(Config.white_color, 18, true)),
      ),
    );
  }
}


class _CrearBoton extends StatefulWidget{

  const _CrearBoton({Key?key,
    required this.title,
    required this.subtitle,
    required this.currentwidth,
    required this.imageRoute,
    required this.destinationRoute}) : super(key:key);

  final String title, subtitle, imageRoute, destinationRoute;
  final double currentwidth;

  @override
  _CrearBotonState createState() => _CrearBotonState();

}

class _CrearBotonState extends State<_CrearBoton> {
  bool isPressed = false; // Variable para controlar si el botón está presionado o no.

  @override
  Widget build(BuildContext context) {
    Config configuracion = Config();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, widget.destinationRoute);
      },
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
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: isPressed ? Config.second_color : Config.white_color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [configuracion.aplicarSombra(0.1, 3, 7, const Offset(0, 1))],
        ),
        width: widget.currentwidth - 30,
        child: Row(
          children: [
            _ImageContainer(imageRoute: widget.imageRoute, isPressed: isPressed,),
            _Content(title: widget.title, subtitle: widget.subtitle, isPressed: isPressed,),
          ],
        ),
      ),
    );
  }
}


class _ImageContainer extends StatefulWidget{
  const _ImageContainer({Key?key, required this.imageRoute, required this.isPressed}): super(key:key);
  final String imageRoute;
  final bool isPressed;

  @override
  _ImageContainerState createState() => _ImageContainerState();

}

class _ImageContainerState extends State<_ImageContainer>{

  @override
  Widget build(BuildContext context){
    const Radius radioImages = Radius.circular(15);
    Config configuracion = Config();

    return Container(
      height: 70,
      width: 120,
      decoration: BoxDecoration(
          boxShadow: [configuracion.aplicarSombra(0.05, 5, 7, const Offset(0, 3))]
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: radioImages, topLeft: radioImages),
              boxShadow: [Config().aplicarSombra(widget.isPressed ? .3 : 0, 5, 7, const Offset(0, 3))]
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: radioImages, topRight: radioImages,),
              child: Image.asset(
                widget.imageRoute,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          )
      ),
    );
  }

}

class _Content extends StatefulWidget {
  final String title, subtitle;
  final bool isPressed;
  const _Content({Key?key, required this.title, required this.subtitle, required this.isPressed}) : super(key:key);
  
  @override
  _ContentState createState() => _ContentState();
  
}

class _ContentState extends State<_Content>{

  @override
  Widget build(BuildContext context){

    Config configuracion = Config();

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2) ,
            child: Text(widget.title, style: configuracion.aplicarEstilo(widget.isPressed ? Colors.white : Config.second_color, 18, true)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.subtitle, style: configuracion.aplicarEstilo(widget.isPressed ? Colors.white : Config.gray_color, 14, false),
              maxLines: null,
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}