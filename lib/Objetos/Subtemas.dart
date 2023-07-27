import 'package:lerner_plantilla/Objetos/Contenido.dart';

class SubTemas {
  String nombreSubTema = "";
  int ordenSubtema = 1;
  List<Contenido> contenidos;


  SubTemas(this.nombreSubTema,this.ordenSubtema,this.contenidos);

  Map<String, dynamic> toMap(){
    return{
      "nombreSubTema":nombreSubTema,
      "ordenSubtema":ordenSubtema,
    };
  }

}