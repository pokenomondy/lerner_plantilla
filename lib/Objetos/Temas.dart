import 'package:lerner_plantilla/Objetos/Subtemas.dart';

class Temas {
  String nombreTema = "";
  int ordentema = 1;
  List<SubTemas> subtemas;


  Temas(this.nombreTema,this.ordentema, this.subtemas);


  Map<String, dynamic> toMap(){
    return{
      "nombre Tema":nombreTema,
      "Orden tema":ordentema,
    };
  }

}

